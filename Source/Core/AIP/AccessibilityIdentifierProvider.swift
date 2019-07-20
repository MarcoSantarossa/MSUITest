import Foundation

public typealias AIP = AccessibilityIdentifierProvider

public protocol AccessibilityIdentifierProvider: AnyObject {
    associatedtype Element

    static var mainIdentifier: String { get }

    static func elementIdentifier(for element: Element) -> String
}

extension AccessibilityIdentifierProvider where Element: RawRepresentable, Element.RawValue == String {
    public static func elementIdentifier(for element: Element) -> String {
        return mainIdentifier + "." + element.rawValue
    }
}
