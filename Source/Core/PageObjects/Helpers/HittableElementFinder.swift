import XCTest

final class HittableElementFinder {
    static func findSwipingIfNeeded(element: XCUIElement, swipeAction: SwipeAction?) {
        guard let swipeAction = swipeAction else { return }
        var numSwipes = 0
        while (!element.exists || element.frame.isEmpty || !element.isHittable) && numSwipes < swipeAction.maxSwipes {
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
