public class MediaModalBaseController: UIViewController, CartButtonDelegate, CircularButtonConformance, BottomToolbarViewControllerDelegate {
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  weak var mediaPickerControllerDelegate: BottomViewCartItemsDelegate?

  lazy var bottomToolbarView: BottomToolbarView = BottomToolbarView()
  lazy var cartButton: CartButton = CartButton()

  lazy var addPhotoButton: CircularBorderButton = self.makeCircularButton(with: "addPhotoIcon")
  var bottomToolbarConstraint: NSLayoutConstraint!
  
  var customFileName: String?
  
  var newlyTaken: Bool = true
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.black
    
    addSubviews()
    
    cartButton.delegate = self
    bottomToolbarView.controllerDelegate = self
    bottomToolbarView.delegate = mediaPickerControllerDelegate
    
    bottomToolbarView.translatesAutoresizingMaskIntoConstraints = false
    addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
    
    self.cartButton.updateCartItemsLabel(mediaPickerControllerDelegate?.itemsInCart ?? 0)
    addPhotoButton.addTarget(self, action: #selector(onAddNextTap), for: .touchUpInside)
    
    setupConstraints()
    
    bottomToolbarView.lastFileName = self.customFileName
  }
  
  internal func addSubviews() {
    self.view.addSubview(bottomToolbarView)
    self.view.addSubview(addPhotoButton)
    self.view.addSubview(cartButton)
  }
  
  @objc func onAddNextTap() {
    EventHub.shared.modalDismissed?()
    customOnAddNexTap()
  }
  
  internal func customOnAddNexTap() {
    fatalError()
  }
  
  func cartButtonTapped() {
    self.cartButton.cartOpened = !self.cartButton.cartOpened
    self.bottomToolbarView.cartOpened = self.cartButton.cartOpened
  }
  
  func onBackButtonTap() {
    if newlyTaken {
      let alertController = UIAlertController(title: "Discard element", message: "Are you sure you want to discard current element?", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
        alertController.dismiss(animated: true) {
          EventHub.shared.modalDismissed?()
          self.dismiss(animated: true, completion: nil)
        }
      }))
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        alertController.dismiss(animated: true, completion: nil)
      }))
      self.present(alertController, animated: true, completion: nil)
    } else {
      EventHub.shared.modalDismissed?()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  internal func setupConstraints() {
    bottomToolbarConstraint = self.bottomToolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    
    Constraint.on(constraints: [
      self.bottomToolbarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.bottomToolbarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.bottomToolbarConstraint,
      self.bottomToolbarView.heightAnchor.constraint(equalToConstant: Config.PhotoEditor.bottomToolbarHeight - 20),
      
      self.addPhotoButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
      self.addPhotoButton.bottomAnchor.constraint(equalTo: self.bottomToolbarView.topAnchor, constant: -8),
      
      cartButton.centerYAnchor.constraint(equalTo: addPhotoButton.centerYAnchor),
      cartButton.trailingAnchor.constraint(equalTo: addPhotoButton.leadingAnchor, constant: Config.BottomView.CartButton.rightMargin),
      cartButton.heightAnchor.constraint(equalToConstant: Config.BottomView.CartButton.size),
      cartButton.widthAnchor.constraint(equalToConstant: Config.BottomView.CartButton.size)
    ])
  }
}