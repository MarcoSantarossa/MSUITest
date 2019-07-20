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
