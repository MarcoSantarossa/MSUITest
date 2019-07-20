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

import MSUITest
import XCTest

final class HomePage {
    typealias Element = HomeAIP.Element
}

extension HomePage: PageObjectUIElementProvider, PageObject {
    func uiElement(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElement {
        let query = self.query(for: element, in: queryProvider)

        let identifier = HomeAIP.elementIdentifier(for: element)
        return query[identifier]
    }

    private func query(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElementQuery {
        switch element {
        case .mainView:
            return queryProvider.otherElements
        case .tableView:
            return queryProvider.tables
        }
    }
}

// MARK: - Given
extension HomePage {
    func givenPage() -> HomePage {
        XCUIApplication().launchTestMode(customArguments: [
            "-coordinatorUnderUITest", "HomeCoordinator"
            ])

        return self
    }
}

// MARK: - Should
extension HomePage {
    @discardableResult
    func shouldSeeLabelPage() -> HomePage {

        LabelPage()
            .thenIShouldSee(element: .mainView)

        return self
    }

    @discardableResult
    func shouldSeeButtonPage() -> HomePage {

        ButtonPage()
            .thenIShouldSee(element: .mainView)

        return self
    }
}
