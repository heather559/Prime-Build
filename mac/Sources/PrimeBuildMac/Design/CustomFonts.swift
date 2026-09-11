import CoreText
import Foundation

enum CustomFonts {
    static let ivyMode: String = {
        guard
            let url = Bundle.module.url(forResource: "IvyMode-Regular", withExtension: "ttf"),
            let provider = CGDataProvider(url: url as CFURL),
            let cgFont = CGFont(provider)
        else {
            return "Georgia"
        }
        CTFontManagerRegisterGraphicsFont(cgFont, nil)
        return (cgFont.postScriptName as String?) ?? "Georgia"
    }()
}
