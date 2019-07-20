import XCTest

public protocol PageObjectWhen: AnyObject {
    associatedtype Element

    @discardableResult
    func whenTap(element: Element, coordinates: CGPoint?, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self
    @discardableResult
    func whenTapCell(in parentElement: Element, at index: Int, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self
    @discardableResult
    func whenTap(coordinates: CGPoint) -> Self
    @discardableResult
    func whenTapBackButton() -> Self
    @discardableResult
    func whenTapAlertButton(at index: Int, timeout: TimeInterval?) -> Self
    @discardableResult
    func whenTapActionSheetButton(at index: Int, timeout: TimeInterval?) -> Self
    @discardableResult
    func whenType(_ text: String, in element: Element, shouldReplace: Bool, timeout: TimeInterval?, swipeAction: SwipeAction?) -> Self
    @discardableResult
    func whenSelectDatePicker(wheels: [String], timeout: TimeInterval?) -> Self
    @discardableResult
    func whenAcceptLocationRequest() -> Self
    @discardableResult
    func whenSwipe(_ swipeAction: SwipeAction, timeout: TimeInterval?) -> Self
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
    public func whenTap(element: Element, coordinates: CGPoint? = nil, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
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
    public func whenTapCell(in parentElement: Element, at index: Int, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
        let tableElement = self.uiElement(for: parentElement, in: XCUIApplication())
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
    public func whenType(_ text: String, in element: Element, shouldReplace: Bool = true, timeout: TimeInterval? = nil, swipeAction: SwipeAction? = nil) -> Self {
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
    public func whenSlide(element: Element, toNormalizedSliderPosition: CGFloat, timeout: TimeInterval?) -> Self {
        let uiElement = self.uiElement(for: element, in: XCUIApplication())
        uiElement.waitIfNeeded(timeout: timeout)

        uiElement.adjust(toNormalizedSliderPosition: toNormalizedSliderPosition)

        return self
    }

}
