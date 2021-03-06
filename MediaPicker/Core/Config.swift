import UIKit
import AVFoundation

public struct Config {
  public static var tabsToShow: [GalleryTab] = [.libraryTab, .cameraTab, .audioTab]
  
  public struct PageIndicator {
    public static var backgroundColor: UIColor = UIColor(red: 0, green: 3 / 255, blue: 10 / 255, alpha: 1)
    public static var textColor: UIColor = UIColor.white
    public static var initialTab = GalleryTab.cameraTab
  }
  
  public struct BottomView {
    public static var backgroundColor: UIColor = .black
    public static var height: CGFloat = 100
    
    public struct BackButton {
      public static var size: CGFloat = 40
      public static var leftMargin: CGFloat = 16
      public static var icon = MediaPickerBundle.image("arrowLeftIcon")
    }
    
    public struct Cart {
      public static var selectedGuid: String?
    }
    
    public struct SaveButton {
      public static var rightMargin: CGFloat = -16
      public static var icon = MediaPickerBundle.image("saveIcon")?.imageWithInsets(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    public struct ShutterButton {
      public static var size: CGFloat = 65
    }
    
    public struct CartButton {
      public static var size: CGFloat = 40
      public static var rightMargin: CGFloat = -16
      public static var bottomMargin: CGFloat = -16
    }
  }
  
  public enum GalleryTab {
    case libraryTab
    case cameraTab
    case audioTab
  }
  
  public struct Camera {
    public static var allowVideoEdit = true
    public static var allowPhotoEdit = true
    
    public enum RecordMode { case photo, video }
    
    public static var recordMode = RecordMode.photo
    
    public struct ShutterButton {
      public static var numberColor: UIColor = UIColor(red: 54 / 255, green: 56 / 255, blue: 62 / 255, alpha: 1)
    }
  }
  
  public struct Audio {
    public static var allowAudioEdit = true
  }
  
  public struct Grid {
    public struct ArrowButton {
      public static var tintColor: UIColor = .white
    }
    
    public struct FrameView {
      public static var fillColor: UIColor = UIColor(red: 32/255.0, green: 71/255.0, blue: 134/255.0, alpha: 1.0)
      public static var borderColor: UIColor = UIColor(red: 32/255.0, green: 71/255.0, blue: 134/255.0, alpha: 1.0)
    }
    
    struct Dimension {
      static let columnCount: CGFloat = 4
      static let cellSpacing: CGFloat = 2
    }
  }
  
  public struct EmptyView {
    public static var image: UIImage? = MediaPickerBundle.image("gallery_empty_view_image")
    public static var textColor: UIColor = UIColor(red: 102 / 255, green: 118 / 255, blue: 138 / 255, alpha: 1)
  }
  
  public struct TranslationKeys {
    public static var permissionLabelKey = "LandaxApp_Gallery_GaleryAndCamera_Permission"
    public static var goToSettingsKey = "LandaxApp_Gallery_Permission_Button"
    public static var libraryTabTitleKey = "LandaxApp_Gallery_Library_Title"
    public static var cameraTabTitleKey = "LandaxApp_Gallery_Camera_Title"
    public static var audioTabTitleKey = "LandaxApp_Gallery_Audio_Title"
    
    public static var imageFileTitleKey = "LandaxApp_Gallery_Media_Type_Image"
    public static var videoFileTitleKey = "LandaxApp_Gallery_Media_Type_Video"
    public static var audioFileTitleKey = "LandaxApp_Gallery_Media_Type_VoiceNote"
    
    public static var tapToPauseLabelKey = "LandaxApp_Media_Gallery_Audio_PauseRecording"
    public static var tapToResetLabelKey = "LandaxApp_Media_Gallery_Audio_ResetRecording"
    public static var tapToContinueLabelKey = "LandaxApp_Media_Gallery_Audio_ContinueRecording"
    public static var tapToStartLabelKey = "LandaxApp_Media_Gallery_Audio_StartRecording"
    
    public static var filenameInputPlaceholderKey = "LandaxApp_Gallery_FilenamePlaceholder"
    
    public static var cancelKey = "LandaxApp_Common_NavButton_Cancel"
    public static var deleteKey = "LandaxApp_Common_Delete"
    public static var discardKey = "LandaxApp_Common_NavButton_Discard"
    
    public static var discardElementKey = "LandaxApp_Media_Discard_Element"
    public static var discardElementDescriptionKey = "LandaxApp_Media_Discard_Element_Description"
    
    public static var discardCartItemsKey = "LandaxApp_Media_Discard_Cart_Items"
    public static var discardCartItemsDescriptionKey = "LandaxApp_Media_Discard_Cart_Items_Description"
    
    public static var deleteElementKey = "LandaxApp_Media_Delete_Element"
    public static var deleteElementDescriptionKey = "LandaxApp_Media_Delete_Element_Description"
    
    public static var discardChangesKey = "LandaxApp_Media_Discard_Changes"
    public static var discardChangesDescriptionKey = "LandaxApp_Media_Discard_Changes_Description"
    
    public static var tapForImageHoldForVideoKey = "LandaxApp_Media_TapForImageHoldForVideo"
  }
  
  public struct Permission {
    public static var shouldCheckPermission = true
    public static var image: UIImage? = MediaPickerBundle.image("gallery_permission_view_camera")
    public static var textColor: UIColor = UIColor(red: 102 / 255, green: 118 / 255, blue: 138 / 255, alpha: 1)
    
    public static var closeImage: UIImage? = MediaPickerBundle.image("gallery_close")
    public static var closeImageTint: UIColor = UIColor(red: 109 / 255, green: 107 / 255, blue: 132 / 255, alpha: 1)

    public struct Button {
      public static var textColor: UIColor = UIColor.white
      public static var highlightedTextColor: UIColor = UIColor.lightGray
      public static var backgroundColor = UIColor(red: 40 / 255, green: 170 / 255, blue: 236 / 255, alpha: 1)
    }
  }
  
  public struct Font {
    public struct Main {
      public static var light: UIFont = UIFont.systemFont(ofSize: 1)
      public static var regular: UIFont = UIFont.systemFont(ofSize: 1)
      public static var bold: UIFont = UIFont.boldSystemFont(ofSize: 1)
      public static var medium: UIFont = UIFont.boldSystemFont(ofSize: 1)
    }
    
    public struct Text {
      public static var regular: UIFont = UIFont.systemFont(ofSize: 1)
      public static var bold: UIFont = UIFont.boldSystemFont(ofSize: 1)
      public static var semibold: UIFont = UIFont.boldSystemFont(ofSize: 1)
    }
  }
  
  public struct VideoRecording {
    public static var maxBytesCount: Int64?
    public static var maxLengthInSeconds: Int?
  }
  
  public struct CartButton {
    public static var textColor = UIColor.white
    public static var font = UIFont.systemFont(ofSize: 18, weight: .light)
    public static var cartExpandedImage = MediaPickerBundle.image("arrowDownIcon")?.imageWithInsets(insets: UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7))
  }
  
  public struct PhotoEditor {
    public static var topToolbarHeight: CGFloat = 60
    public static var bottomToolbarHeight: CGFloat = 110
    public static var editorCircularButtonSize: CGFloat = 40
    public static var textFont = UIFont(name: "Helvetica", size: 24)
    public static var lineWidth: CGFloat = 4.0
  }
}
