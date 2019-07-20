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
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainCoordinator: Coordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        let rootVC = UINavigationController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()

        self.window = window

        mainCoordinator = createMainCoordinator(with: rootVC)
        mainCoordinator.start()

        disableAnimationIfNeeded()

        return true
    }

    private func createMainCoordinator(with rootViewController: UINavigationController) -> Coordinator {
        if let coordinatorUnderUITest = UserDefaults.standard.string(forKey: "coordinatorUnderUITest") {
            return UITestCoordinator(rootViewController: rootViewController,
                                     coordinatorUnderUITest: coordinatorUnderUITest)
        } else {
            return MainCoordinator(rootViewController: rootViewController)
        }
    }

    private func disableAnimationIfNeeded() {
        guard UITestLaunchArgument.animationsDisabled.isActive else { return }
        UIView.setAnimationsEnabled(false)
    }
}
