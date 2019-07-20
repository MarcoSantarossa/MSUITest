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

/// Abstract Page object to provide the default functionality for a concrete Page object.
/// * Attention: **None** of these methods require a custom implementation. Everything is provided with internal extensions.
public protocol PageObjectWhen: AnyObject {
    associatedtype Element

    /// Performs a tap in a element.
    ///
    /// - Parameters:
    ///   - element: Element to tap.
    ///   - coordinates: _Optional_ coordinates to perform the tap inside the element.
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    ///   - swipeAction: _Optional_ swipe action to find a not visible cell.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenTap(element: Element, coordinates: CGPoint?, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self

    /// Performs a tap inside a cell.
    ///
    /// - Parameters:
    ///   - tableView: Table view where to find the cell.
    ///   - index: Index of the cell to tap
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    ///   - swipeAction: _Optional_ swipe action to find a not visible cell.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenTapCell(in tableView: Element, at index: Int, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self

    /// Performs a tap in the screen to a specific coordinate.
    ///
    /// - Parameter coordinates: Location to tap.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenTap(coordinates: CGPoint) -> Self

    /// Performs a tap in the back button of a navigation controller.
    ///
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenTapBackButton() -> Self

    /// Performs a tap in an alert view button.
    ///
    /// - Parameters:
    ///   - index: Index of the button to tap.
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenTapAlertButton(at index: Int, timeout: TimeInterval?) -> Self

    /// Performs a tap in an action sheet button.
    ///
    /// - Parameters:
    ///   - index: Index of the button to tap.
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenTapActionSheetButton(at index: Int, timeout: TimeInterval?) -> Self

    /// Performs a typing inside an UI element.
    ///
    /// - Parameters:
    ///   - text: Text to type.
    ///   - element: Element where to type the text.
    ///   - shouldReplace: Replace the current text of the element. Default true.
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    ///   - swipeAction: _Optional_ swipe action to find a not visible cell.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenType(_ text: String, in element: Element, shouldReplace: Bool, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self

    /// Performs the pick of a date from a date picker.
    ///
    /// - Parameters:
    ///   - wheels: The day, month and year to pick. (The order depends on the format of your date picker).
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenSelectDatePicker(wheels: [String], timeout: TimeInterval?) -> Self

    /// Performs the tap on the GPS permission request of iOS.
    ///
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenAcceptLocationRequest() -> Self

    /// Performs a swipe in the screen.
    ///
    /// - Parameters:
    ///   - swipeAction: Swipe action to perform.
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenSwipe(_ swipeAction: SwipeAction, timeout: TimeInterval?) -> Self

    /// Performs a scroll in a scrollable view.
    ///
    /// - Parameters:
    ///   - element: Scrollable element to scroll.
    ///   - toNormalizedSliderPosition: Position where to scroll.
    ///   - timeout: _Optional_ timeout to wait the visibility of the element.
    /// - Returns: itself to use in a chain of calls.
    @discardableResult
    func whenSlide(element: Element, toNormalizedSliderPosition: CGFloat, timeout: TimeInterval?) -> Self
}

extension PageObjectWhen where Self: PageObjectUIElementProvider {
    private func waitTableContentLoadedIfNeeded(in table: XCUIElement, timeout: TimeInterval?) {
        let firstCell = table.cells.element(boundBy: 0)
        firstCell.waitIfNeeded(timeout: timeout)
    }

    private func performSwipe(_ swipeAction: SwipeAction) {
        var numSwipes = 0
        while numSwipes < swipeAction.maxSwipes {
            switch swipeAction.direction {
            case .up:
                swipeAction.target.swipeUp()
            case .down:
                swipeAction.target.swipeDown()
            case .left:
                swipeAction.target.swipeLeft()
            case .right:
                swipeAction.target.swipeRight()
            }

            numSwipes += 1
        }
    }
}

extension PageObjectWhen where Self: PageObjectUIElementProvider {
    @discardableResult
    public func whenTap(element: Self.Element, coordinates: CGPoint? = nil, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
        let uiElement = self.uiElement(for: element, in: XCUIApplication())
        uiElement.waitIfNeeded(timeout: timeout)

        HittableElementFinder.findSwipingIfNeeded(element: uiElement, swipeAction: swipeAction)

        if let coordinates = coordinates {
            let normalized = uiElement.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            let coordinate = normalized.withOffset(CGVector(dx: coordinates.x, dy: coordinates.y))
            coordinate.tap()
        } else {
            uiElement.tap()
        }

        return self
    }

    @discardableResult
    public func whenTapCell(in tableView: Self.Element, at index: Int, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
        let tableElement = self.uiElement(for: tableView, in: XCUIApplication())
        tableElement.waitIfNeeded(timeout: timeout)

        waitTableContentLoadedIfNeeded(in: tableElement, timeout: timeout)

        let cellToTap = tableElement.cells.element(boundBy: index)

        HittableElementFinder.findSwipingIfNeeded(element: cellToTap, swipeAction: swipeAction)

        cellToTap.tap()

        return self
    }

    @discardableResult
    public func whenTap(coordinates: CGPoint) -> Self {
        let normalized = XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: coordinates.x, dy: coordinates.y))
        coordinate.tap()

        return self
    }

    @discardableResult
    public func whenTapBackButton() -> Self {
        XCUIApplication().navigationBars.buttons.element(boundBy: 0).tap()

        return self
    }

    @discardableResult
    public func whenType(_ text: String, in element: Self.Element, shouldReplace: Bool = true, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
        // Tap to get the focus
        whenTap(element: element, timeout: timeout, swipeAction: swipeAction)

        let uiElement = self.uiElement(for: element, in: XCUIApplication())
        if shouldReplace {
            uiElement.clearTextIfNeeded()
        }

        uiElement.typeText(text)

        return self
    }

    @discardableResult
    public func whenTapAlertButton(at index: Int, timeout: TimeInterval? = nil) -> Self {
        let alert = XCUIApplication().alerts.element
        alert.waitIfNeeded(timeout: timeout)

        alert.buttons.element(boundBy: index).tap()

        return self
    }

    @discardableResult
    public func whenTapActionSheetButton(at index: Int, timeout: TimeInterval?) -> Self {
        let actionSheet = XCUIApplication().sheets.firstMatch
        actionSheet.waitIfNeeded(timeout: timeout)

        actionSheet.buttons.element(boundBy: index).tap()

        return self
    }

    @discardableResult
    public func whenSelectDatePicker(wheels: [String], timeout: TimeInterval? = nil) -> Self {
        let pickerWheels = XCUIApplication().pickerWheels
        pickerWheels.element(boundBy: 0).waitIfNeeded(timeout: timeout)

        wheels.enumerated().reversed().forEach { index, elem in
            pickerWheels.element(boundBy: index).adjust(toPickerWheelValue: elem)
        }

        return self
    }

    @discardableResult
    public func whenAcceptLocationRequest() -> Self {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowButtonUIElement = springboard.buttons["Allow"]
        allowButtonUIElement.waitIfNeeded(timeout: 0.300)

        if allowButtonUIElement.exists {
            allowButtonUIElement.tap()
        }

        return self
    }

    @discardableResult
    public func whenSwipe(_ swipeAction: SwipeAction, timeout: TimeInterval? = nil) -> Self {
        swipeAction.target.waitIfNeeded(timeout: timeout)

        performSwipe(swipeAction)

        return self
    }

    @discardableResult
    public func whenSlide(element: Self.Element, toNormalizedSliderPosition: CGFloat, timeout: TimeInterval?) -> Self {
        let uiElement = self.uiElement(for: element, in: XCUIApplication())
        uiElement.waitIfNeeded(timeout: timeout)

        uiElement.adjust(toNormalizedSliderPosition: toNormalizedSliderPosition)

        return self
    }

}
