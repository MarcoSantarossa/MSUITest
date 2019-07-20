import MSUITest

final class MainAIP: AIP {
    static var mainIdentifier: String = "main"
}

extension MainAIP {
    enum Element: String {
        case mainView
        case label
    }
}
