//
//    Copyright (c) 2019 Marco Santarossa
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

import XCTest

public protocol PageObjectShould: AnyObject {
    associatedtype Element

    @discardableResult
    func thenIShouldSee(text: String, timeout: TimeInterval?) -> Self
    @discardableResult
    func thenIShouldSee(element: Element, text: String?, timeout: TimeInterval?) -> Self
    @discardableResult
    func thenIShouldSee(in table: Element, at index: Int, cellElement: Element, text: String?, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self
    @discardableResult
    func thenIShouldSee(in table: Element, at index: Int, text: String, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self
    @discardableResult
    func thenIShouldNotSee(element: Element, delay: TimeInterval?) -> Self
    @discardableResult
    func thenIShouldSeeNavigationBar(text: String, timeout: TimeInterval?) -> Self
    @discardableResult
    func thenIShouldSeeKeyboard() -> Self
    @discardableResult
    func thenIShouldNotSeeKeyboard() -> Self
    @discardableResult
    func thenIShouldSeeAlert(title: String, message: String, timeout: TimeInterval?) -> Self
    @discardableResult
    func thenIShouldNotSeeAlert() -> Self
}

extension PageObjectShould where Self: PageObjectUIElementProvider {
    private func errorMessage(for element: Self.Element, in functionName: StaticString) -> String {
        return "\(functionName) for element \(element)"
    }

    private func assertExistence(of uiElement: XCUIElement, failureMessage: @autoclosure () -> String, timeout: TimeInterval?) {
        let exist: Bool
        if let timeout = timeout {
            exist = uiElement.waitForExistence(timeout: timeout)
        } else {
            exist = uiElement.exists
        }

        XCTAssertTrue(exist, failureMessage())
    }

    private func assert(text: String, of uiElement: XCUIElement, failureMessage: @autoclosure () -> String) {
        let texts = [uiElement.value as? String, uiElement.label]
        let isTextFound = texts.lazy
                            .compactMap { $0 }
                            .contains(text)

        XCTAssertTrue(isTextFound, failureMessage())
    }
}

// MARK: - Then
extension PageObjectShould where Self: PageObjectUIElementProvider {
    @discardableResult
    public func thenIShouldSee(text: String, timeout: TimeInterval? = nil) -> Self {
        let uiElement = XCUIApplication().staticTexts[text]
        uiElement.waitIfNeeded(timeout: timeout)

        return self
    }
    @discardableResult
    public func thenIShouldSee(element: Self.Element, text: String? = nil, timeout: TimeInterval? = nil) -> Self {
        let uiElement = self.uiElement(for: element, in: XCUIApplication())

        assertExistence(of: uiElement, failureMessage: errorMessage(for: element, in: #function), timeout: timeout)

        if let text = text {
            assert(text: text,
                   of: uiElement,
                   failureMessage: "Failed \(#function) for element \(element), found value \(String(describing: uiElement.value)) and label \(uiElement.label)")
        }

        return self
    }

    @discardableResult
    public func thenIShouldSee(in table: Self.Element, at index: Int, cellElement: Self.Element, text: String? = nil, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
        let tableUIElement = self.uiElement(for: table, in: XCUIApplication())
        tableUIElement.waitIfNeeded(timeout: timeout)

        tableUIElement.waitIfNeeded(timeout: timeout)

        let cellToFind = tableUIElement.cells.element(boundBy: index)

        HittableElementFinder.findSwipingIfNeeded(element: cellToFind, swipeAction: swipeAction)

        let cellUIElement = self.uiElement(for: cellElement, in: cellToFind)
        assertExistence(of: cellUIElement, failureMessage: errorMessage(for: cellElement, in: #function), timeout: timeout)

        if let text = text {
            assert(text: text,
                   of: cellUIElement,
                   failureMessage: "\(#function) found value \(String(describing: cellUIElement.value)) and label \(cellUIElement.label)")
        }

        return self
    }

    @discardableResult
    public func thenIShouldSee(in table: Self.Element, at index: Int, text: String, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
        let tableUIElement = self.uiElement(for: table, in: XCUIApplication())
        tableUIElement.waitIfNeeded(timeout: timeout)

        tableUIElement.waitIfNeeded(timeout: timeout)

        let cellToFind = tableUIElement.cells.element(boundBy: index)

        HittableElementFinder.findSwipingIfNeeded(element: cellToFind, swipeAction: swipeAction)

        let staticText = cellToFind.staticTexts[text]
        staticText.waitIfNeeded(timeout: timeout)

        XCTAssertTrue(staticText.exists, "\(#function) expected text \(text)")

        return self
    }

    @discardableResult
    public func thenIShouldNotSee(element: Self.Element, delay: TimeInterval? = nil) -> Self {
        let uiElement = self.uiElement(for: element, in: XCUIApplication())

        if let delay = delay {
            Thread.sleep(forTimeInterval: delay)
        }

        if uiElement.exists && uiElement.isHittable {
            XCTFail(errorMessage(for: element, in: #function))
        }

        return self
    }

    @discardableResult
    public func thenIShouldSeeNavigationBar(text: String, timeout: TimeInterval? = nil) -> Self {
        let uiElement = XCUIApplication().navigationBars.otherElements[text]
        uiElement.waitIfNeeded(timeout: timeout)

        XCTAssertTrue(uiElement.exists, "\(#function) expected text \(text)")

        return self
    }

    @discardableResult
    public func thenIShouldSeeKeyboard() -> Self {
        XCTAssertEqual(XCUIApplication().keyboards.count, 1)

        return self
    }

    @discardableResult
    public func thenIShouldNotSeeKeyboard() -> Self {
        XCTAssertEqual(XCUIApplication().keyboards.count, 0)

        return self
    }

    @discardableResult
    public func thenIShouldSeeAlert(title: String, message: String, timeout: TimeInterval? = nil) -> Self {
        let uiElement = XCUIApplication().alerts.element.staticTexts[message]

        assertExistence(of: uiElement, failureMessage: "Alert not found with message \(message)", timeout: timeout)

        XCTAssertEqual(XCUIApplication().alerts.element.label, title)

        return self
    }

    @discardableResult
    public func thenIShouldNotSeeAlert() -> Self {
        XCTAssertEqual(XCUIApplication().alerts.count, 0)

        return self
    }
}
