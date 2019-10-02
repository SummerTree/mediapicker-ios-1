import Foundation
import AVFoundation
import PhotosUI
import Photos

protocol CameraManDelegate: AnyObject {
  func cameraManNotAvailable(_ cameraMan: CameraMan)
  func cameraManDidStart(_ cameraMan: CameraMan)
  func cameraMan(_ cameraMan: CameraMan, didChangeInput input: AVCaptureDeviceInput)
  func takenAsset(_ cameraMan: CameraMan, asset: PHAsset?)
}

class CameraMan : NSObject, AVCapturePhotoCaptureDelegate {
  weak var delegate: CameraManDelegate?
  
  let session = AVCaptureSession()
  let queue = DispatchQueue(label: "no.hyper.Gallery.Camera.SessionQueue", qos: .background)
  let savingQueue = DispatchQueue(label: "no.hyper.Gallery.Camera.SavingQueue", qos: .background)
  
  var backCamera: AVCaptureDeviceInput?
  var frontCamera: AVCaptureDeviceInput?
  var photoOutput: AVCapturePhotoOutput?
  var movieOutput: ClosuredAVCaptureMovieFileOutput?
  var photoSettings: AVCapturePhotoSettings!
  
  deinit {
    stop()
  }
  
  // MARK: - Setup
  
  func setup() {
    if Permission.Camera.status == .authorized {
      self.start()
    } else {
      self.delegate?.cameraManNotAvailable(self)
    }
  }
  
  func setupDevices() {
    // Input
    AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: nil, position: AVCaptureDevice.Position.unspecified)
      .devices
      .filter {
        return $0.hasMediaType(.video)
      }.forEach {
        switch $0.position {
        case .front:
          self.frontCamera = try? AVCaptureDeviceInput(device: $0)
        case .back:
          self.backCamera = try? AVCaptureDeviceInput(device: $0)
        default:
          break
        }
    }
    
    // Output
    photoOutput = AVCapturePhotoOutput()
    photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
    photoSettings.isAutoStillImageStabilizationEnabled = false
    movieOutput = ClosuredAVCaptureMovieFileOutput(sessionQueue: queue)
  }
  
  func addInput(_ input: AVCaptureDeviceInput) {
    configurePreset(input)
    
    if session.canAddInput(input) {
      session.addInput(input)
      
      DispatchQueue.main.async {
        self.delegate?.cameraMan(self, didChangeInput: input)
      }
    }
  }
  
  // MARK: - Session
  
  var currentInput: AVCaptureDeviceInput? {
    return session.inputs.first as? AVCaptureDeviceInput
  }
  
  fileprivate func start() {
    // Devices
    setupDevices()
    
    guard let input = backCamera, let imageOutput = photoOutput, let movieOutput = movieOutput else { return }
    
    addInput(input)
    
    if session.canAddOutput(imageOutput) {
      session.addOutput(imageOutput)
    }
    
    movieOutput.addToSession(session)
    
    queue.async {
      self.session.startRunning()
      
      DispatchQueue.main.async {
        self.delegate?.cameraManDidStart(self)
      }
    }
  }
  
  func stop() {
    self.session.stopRunning()
  }
  
  func switchCamera(_ completion: (() -> Void)? = nil) {
    guard let currentInput = currentInput
      else {
        completion?()
        return
    }
    
    queue.async {
      guard let input = (currentInput == self.backCamera) ? self.frontCamera : self.backCamera
        else {
          DispatchQueue.main.async {
            completion?()
          }
          return
      }
      
      self.configure {
        self.session.removeInput(currentInput)
        self.addInput(input)
      }
      
      DispatchQueue.main.async {
        completion?()
      }
    }
  }
  
  @available(iOS 11.0, *)
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation() else {
      debugPrint("Error while generating image from photo capture data.")
      self.delegate?.takenAsset(self, asset: nil)
      return
    }
    
    guard let uiImage = UIImage(data: imageData) else {
      debugPrint("Unable to generate UIImage from image data.")
      self.delegate?.takenAsset(self, asset: nil)
      return
    }
    
    self.savePhoto(uiImage, location: lastLocation)
  }
  
  @available(iOS, introduced: 10.0, deprecated: 11.0)
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    
    if let error = error {
      debugPrint("error occured : \(error.localizedDescription)")
    }
    
    if  let sampleBuffer = photoSampleBuffer,
      let previewBuffer = previewPhotoSampleBuffer,
      let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
      debugPrint(UIImage(data: dataImage)?.size as Any)
      
      let dataProvider = CGDataProvider(data: dataImage as CFData)
      let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
      let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
      
      self.savePhoto(image, location: lastLocation)
    } else {
      debugPrint("some error here")
    }
  }
  
  var lastLocation: CLLocation?
  
  func takePhoto(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?) {
    guard let connection = photoOutput?.connection(with: .video) else { return }
    
    connection.videoOrientation = Utils.videoOrientation()
    lastLocation = location
    
    queue.async {
      self.photoOutput?.capturePhoto(with: AVCapturePhotoSettings(from: self.photoSettings), delegate: self)
    }
  }
  
  func savePhoto(_ image: UIImage, location: CLLocation?) {
    self.save({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }, location: location)
  }
  
  func save(_ req: @escaping (() -> PHAssetChangeRequest?), location: CLLocation?) {
    var localIdentifier: String?
    
    savingQueue.async {
      do {
        try PHPhotoLibrary.shared().performChangesAndWait {
          if let request = req() {
            localIdentifier = request.placeholderForCreatedAsset?.localIdentifier
            
            request.creationDate = Date()
            request.location = location
          }
        }
        
        DispatchQueue.main.async {
          if let localIdentifier = localIdentifier {
            self.delegate?.takenAsset(self, asset: Fetcher.fetchAsset(localIdentifier))
          } else {
            self.delegate?.takenAsset(self, asset: nil)
          }
        }
      } catch {
        DispatchQueue.main.async {
          self.delegate?.takenAsset(self, asset: nil)
        }
      }
    }
  }
  
  func flash(_ mode: AVCaptureDevice.FlashMode) {
    guard photoOutput?.supportedFlashModes.contains(mode) == true else { return }
    self.photoSettings.flashMode = mode
  }
  
  func focus(_ point: CGPoint) {
    guard let device = currentInput?.device, device.isFocusModeSupported(AVCaptureDevice.FocusMode.locked) else { return }
    
    queue.async {
      self.lock {
        device.focusPointOfInterest = point
      }
    }
  }
  
  // MARK: - Lock
  
  func lock(_ block: () -> Void) {
    if let device = currentInput?.device, (try? device.lockForConfiguration()) != nil {
      block()
      device.unlockForConfiguration()
    }
  }
  
  // MARK: - Configure
  func configure(_ block: () -> Void) {
    session.beginConfiguration()
    block()
    session.commitConfiguration()
  }
  
  // MARK: - Preset
  
  func configurePreset(_ input: AVCaptureDeviceInput) {
    for asset in preferredPresets() {
      if input.device.supportsSessionPreset(asset) && self.session.canSetSessionPreset(asset) {
        self.session.sessionPreset = asset
        return
      }
    }
  }
  
  func preferredPresets() -> [AVCaptureSession.Preset] {
    return [
      .high,
      .medium,
      .low
    ]
  }
  
  func isRecording() -> Bool {
    return self.movieOutput?.isRecording() ?? false
  }
  
  func startVideoRecord(location: CLLocation?, startCompletion: ((Bool) -> Void)?) {
    lastLocation = location
    
    self.movieOutput?.startRecording(startCompletion: startCompletion, stopCompletion: { url in
      if let url = url {
        self.saveVideo(at: url, location: location)
      } else {
        self.delegate?.takenAsset(self, asset: nil)
      }
    })
  }
  
  func stopVideoRecording() {
    self.movieOutput?.stopVideoRecording()
  }
  
  func saveVideo(at path: URL, location: CLLocation?) {
    self.save({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path)
    }, location: location)
  }
}
