import XCTest

public protocol PageObjectUIElementProvider: AnyObject {
    associatedtype Element

    func uiElement(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElement
}
