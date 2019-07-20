import XCTest

public protocol PageObject: PageObjectWhen, PageObjectShould {

    @discardableResult
    func delay(_ delay: TimeInterval) -> Self

    static func terminate()
}

extension PageObject {
    @discardableResult
    public func delay(_ delay: TimeInterval) -> Self {
        Thread.sleep(forTimeInterval: delay)

        return self
    }
}

extension PageObject {
    public static func terminate() {
        XCUIApplication().terminate()
    }
}
