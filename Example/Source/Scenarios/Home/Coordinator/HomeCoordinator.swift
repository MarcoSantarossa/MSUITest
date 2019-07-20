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

final class HomeCoordinator: Coordinator {

    private unowned let navigationController: UINavigationController

    private var coords = [String: Coordinator]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onCellSeleted: (HomeCell) -> Void = { [weak self] in
            guard let self = self else { return }
            let coordinator = self.makeCoordinator(for: $0)
            coordinator.start()
            self.coords[type(of: coordinator).identifier] = coordinator
        }

        let view = HomeViewController(onCellSelected: onCellSeleted)
        navigationController.setViewControllers([view], animated: false)
    }

    private func makeCoordinator(for cell: HomeCell) -> Coordinator {
        switch cell {
        case .label:
            return LabelCoordinator(navigationController: navigationController)
        default:
            fatalError()
        }
    }
}
