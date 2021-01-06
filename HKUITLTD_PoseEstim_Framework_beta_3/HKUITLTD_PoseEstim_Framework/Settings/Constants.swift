
public enum Constants {
  // MARK: - Constants related to the image processing
  public static let bgraPixel = (channels: 4, alphaComponent: 3, lastBgrComponent: 2)
  public static let rgbPixelChannels = 3
  public static let maxRGBValue: Float32 = 255.0

  // MARK: - Constants related to the model interperter
  public static let defaultThreadCount = 2
  public static let defaultDelegate: Delegates = .CPU
}
