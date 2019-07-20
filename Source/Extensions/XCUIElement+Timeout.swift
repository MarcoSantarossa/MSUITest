import XCTest

extension XCUIElement {
    func waitIfNeeded(timeout: TimeInterval?) {
        guard let timeout = timeout else { return }
        _ = waitForExistence(timeout: timeout)
    }
}
