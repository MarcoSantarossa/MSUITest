import XCTest

public struct SwipeAction {
    let target: XCUIElement
    let direction: Direction
    let maxSwipes: Int
}

extension SwipeAction {
    public enum Direction {
        case up
        case right
        case down
        case left
    }
}
