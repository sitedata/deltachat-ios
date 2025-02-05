import UIKit

public struct DcColors {
    private static let white                                  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private static let actionCellBackgroundDark               = #colorLiteral(red: 0.1031623408, green: 0.1083367988, blue: 0.1185036376, alpha: 1)


    public static let primary = UIColor.systemBlue
    public static let colorDisabled = UIColor.themeColor(light: UIColor(white: 0.9, alpha: 1), dark: UIColor(white: 0.2, alpha: 1))
    public static let messagePrimaryColor = UIColor.themeColor(light: UIColor.rgb(red: 220, green: 248, blue: 198),
                                                        dark: UIColor.init(hexString: "224508"))
    public static let messageSecondaryColor = UIColor.themeColor(light: UIColor.init(hexString: "ebebed"),
                                                          dark: UIColor.init(hexString: "333333"))
    public static let contactCellBackgroundColor = UIColor.themeColor(light: .white, dark: .black)
    public static let defaultBackgroundColor = UIColor.themeColor(light: .white, dark: .black)
    public static let sharedChatCellBackgroundColor = UIColor.themeColor(light: white, dark: actionCellBackgroundDark)
    public static let chatBackgroundColor = UIColor.themeColor(light: .white, dark: .black)
    public static let checkmarkGreen = UIColor.themeColor(light: UIColor.rgb(red: 112, green: 177, blue: 92))
    public static let defaultTextColor = UIColor.themeColor(light: .darkText, dark: .white)
    public static let grayTextColor = UIColor.themeColor(light: .darkGray, dark: .lightGray)
    public static let grayDateColor = UIColor.themeColor(lightHex: "999999", darkHex: "bbbbbb") // slight variations of lightGray (#aaaaaa)
    public static let middleGray = UIColor(hexString: "848ba7")
    public static let secondaryTextColor = UIColor.themeColor(lightHex: "848ba7", darkHex: "a5abc0")
    public static let inputFieldColor =  UIColor.themeColor(light: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1),
                                                     dark: UIColor(red: 10 / 255, green: 10 / 255, blue: 10 / 255, alpha: 1))
    public static let placeholderColor = UIColor.themeColor(light: UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
                                                     dark: UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1))
    public static let providerPreparationBackground = UIColor.themeColor(lightHex: "#fffdf7b2", darkHex: "##fffdf7b2")
    public static let providerBrokenBackground = UIColor.themeColor(light: SystemColor.red.uiColor, dark: SystemColor.red.uiColor)
    public static let systemMessageBackgroundColor = UIColor.themeColor(light: UIColor.rgb(red: 248, green: 248, blue: 248),
                                                                        dark: UIColor(white: 0.2, alpha: 0.5))
    public static let deaddropBackground = UIColor.themeColor(light: UIColor.init(hexString: "ebebec"), dark: UIColor.init(hexString: "1a1a1c"))
}

public enum SystemColor {
    case red
    case orange
    case yellow
    case green
    case tealBlue
    case blue
    case purple
    case pink

    public var uiColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
        case .orange:
            return UIColor(red: 255 / 255, green: 149 / 255, blue: 0 / 255, alpha: 1)
        case .yellow:
            return UIColor(red: 255 / 255, green: 204 / 255, blue: 0 / 255, alpha: 1)
        case .green:
            return UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        case .tealBlue:
            return UIColor(red: 90 / 255, green: 200 / 255, blue: 250 / 255, alpha: 1)
        case .blue:
            return UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
        case .purple:
            return UIColor(red: 88 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
        case .pink:
            return UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1)
        }
    }
}
