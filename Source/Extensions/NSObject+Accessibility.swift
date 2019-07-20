import UIKit

extension UIAccessibilityIdentification where Self: NSObject {
    public func addAccessibility<T: AccessibilityIdentifierProvider>(aip: T.Type, element: T.Element) {
        let id = T.elementIdentifier(for: element)
        accessibilityIdentifier = id
    }
}
