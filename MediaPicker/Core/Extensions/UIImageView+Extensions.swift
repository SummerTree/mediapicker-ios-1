import UIKit
import Photos

extension UIImageView {
  var contentClippingRect: CGRect {
      guard let image = image else { return bounds }
      guard contentMode == .scaleAspectFit else { return bounds }
      guard image.size.width > 0 && image.size.height > 0 else { return bounds }

      let scale: CGFloat
      if image.size.width > image.size.height {
          scale = bounds.width / image.size.width
      } else {
          scale = bounds.height / image.size.height
      }

      let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
      let x = (bounds.width - size.width) / 2.0
      let y = (bounds.height - size.height) / 2.0

      return CGRect(x: x, y: y, width: size.width, height: size.height)
  }
  
  func loadImage(_ asset: PHAsset) {
    guard frame.size != CGSize.zero else {
      image = MediaPickerBundle.image("gallery_placeholder")
      return
    }
    
    if tag == 0 {
      image = MediaPickerBundle.image("gallery_placeholder")
    } else {
      PHImageManager.default().cancelImageRequest(PHImageRequestID(tag))
    }
    
    let options = PHImageRequestOptions()
    options.isNetworkAccessAllowed = true
    
    let id = PHImageManager.default().requestImage(
      for: asset,
      targetSize: frame.size,
      contentMode: .aspectFill,
      options: options) { [weak self] image, _ in
        self?.image = image
    }
    
    tag = Int(id)
  }
}

extension UIImage {
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
