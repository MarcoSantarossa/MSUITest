import XCTest

extension XCUIElement {
    func clearTextIfNeeded() {
        guard let stringValue = self.value as? String else {
            return
        }

        let deleteString: String = stringValue.lazy.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
        typeText(deleteString)
    }
}
