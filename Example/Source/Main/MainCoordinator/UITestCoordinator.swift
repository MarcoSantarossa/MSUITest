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

import UIKit

final class UITestCoordinator: Coordinator {

    private var coords = [Coordinator]()

    private unowned let rootViewController: UINavigationController
    private let coordinatorUnderUITest: String

    init(rootViewController: UINavigationController, coordinatorUnderUITest: String) {
        self.rootViewController = rootViewController
        self.coordinatorUnderUITest = coordinatorUnderUITest
    }

    func start() {
        let coordinator = createCoordinator()
        coordinator.start()

        coords.append(coordinator)
    }

    private func createCoordinator() -> Coordinator {
        switch coordinatorUnderUITest {
        case HomeCoordinator.identifier:
            return HomeCoordinator(navigationController: rootViewController)
        case LabelCoordinator.identifier:
            return LabelCoordinator(navigationController: rootViewController)
        case ButtonCoordinator.identifier:
            return ButtonCoordinator(navigationController: rootViewController)
        case TextFieldCoordinator.identifier:
            return TextFieldCoordinator(navigationController: rootViewController)
        case ImageCoordinator.identifier:
            return ImageCoordinator(navigationController: rootViewController)
        default:
            fatalError("Coordinator under UI tests not found")
        }
    }
}
