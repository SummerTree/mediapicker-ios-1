class FileNameComposer {
  public static func getAudioFileName() -> String {
    return formatString(firstPart: Config.TranslationKeys.audioFileTitleKey.g_localize(fallback: "VoiceNote"))
  }
  
  public static func getImageFileName() -> String {
    return formatString(firstPart: Config.TranslationKeys.imageFileTitleKey.g_localize(fallback: "Image"))
  }
  
  public static func getVideoFileName() -> String {
    return formatString(firstPart: Config.TranslationKeys.videoFileTitleKey.g_localize(fallback: "Video"))
  }
  
  private static func formatString(firstPart: String) -> String {
    let dateTimeFormatter = DateFormatter()
    dateTimeFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    return "\(firstPart) \(dateTimeFormatter.string(from: Date()))"
  }
}
