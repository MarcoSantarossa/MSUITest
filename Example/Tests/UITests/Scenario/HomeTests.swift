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

class HomeTests: XCTestCase {

    func test_whenLoadView_seeExpectedElements() {
        HomePage()
            .givenPage()

            .thenIShouldSee(element: .mainView, timeout: 0.3)
            .thenIShouldSeeNavigationBar(text: "Home")
            .thenIShouldSee(element: .tableView)
            .thenIShouldSee(in: .tableView, at: 0, text: "label")
            .thenIShouldSee(in: .tableView, at: 1, text: "button")
            .thenIShouldSee(in: .tableView, at: 2, text: "textField")
            .thenIShouldSee(in: .tableView, at: 3, text: "image")
            .thenIShouldSee(in: .tableView, at: 4, text: "alert")
    }

    func test_whenTapLabelCell_seeLabelView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 0)

            .shouldSeeLabelPage()
    }

    func test_whenTapLabelCellAndBackButton_seeMainView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 0)
            .whenTapBackButton()

            .thenIShouldSee(element: .mainView)
    }

    func test_whenTapButtonCell_seeButtonView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 1)

            .shouldSeeButtonPage()
    }

    func test_whenTapButtonCellAndBackButton_seeMainView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 1)
            .whenTapBackButton()

            .thenIShouldSee(element: .mainView)
    }

    func test_whenTapTextFieldCell_seeTextFieldView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 2)

            .shouldSeeTextFieldPage()
    }

    func test_whenTapTextFieldCellAndBackButton_seeMainView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 2)
            .whenTapBackButton()

            .thenIShouldSee(element: .mainView)
    }

    func test_whenTapTextFieldCellAndFocusAndBackButton_doNotSeeKeyboard() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 2)
            .whenFocusTextField()

            .delay(0.2)

            .whenTapBackButton()

            .thenIShouldNotSeeKeyboard()
    }

    func test_whenTapImageCell_seeImageView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 3)

            .shouldSeeImagePage()
    }

    func test_whenTapImageCellAndBackButton_seeMainView() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 3)
            .whenTapBackButton()

            .thenIShouldSee(element: .mainView)
    }

    func test_whenTapAlertCell_seeAlert() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 4)

            .thenIShouldSeeAlert(title: "🚨 Alert 🚨", message: "[ Add here your test ]")
    }

    func test_whenTapAlertCellAndTapCancel_doNotSeeAlert() {
        HomePage()
            .givenPage()

            .whenTapCell(in: .tableView, at: 4)
            .whenTapAlertButton(at: 0)

            .thenIShouldNotSeeAlert()
    }
}
