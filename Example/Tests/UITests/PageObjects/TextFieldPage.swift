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

final class TextFieldPage {
    typealias Element = TextFieldAIP.Element
}

extension TextFieldPage: PageObjectUIElementProvider, PageObject {
    func uiElement(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElement {
        let query = self.query(for: element, in: queryProvider)

        let identifier = TextFieldAIP.elementIdentifier(for: element)
        return query[identifier]
    }

    private func query(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElementQuery {
        switch element {
        case .mainView:
            return queryProvider.otherElements
        case .textField:
            return queryProvider.textFields
        }
    }
}

// MARK: - Given
extension TextFieldPage {
    func givenPage() -> TextFieldPage {
        XCUIApplication().launchTestMode(customArguments: [
            "-coordinatorUnderUITest", "TextFieldCoordinator"
            ])

        return self
    }
}

// MARK: - Then
extension TextFieldPage {
    @discardableResult
    func thenIShouldSeeEmptyTextFieldWithPlaceholder() -> TextFieldPage {
        if #available(iOS 11.0, *) {
            return thenIShouldSee(element: .textField, text: "Try me 🤓")
        } else {
            return thenIShouldSee(element: .textField, text: "")
        }
    }
}
