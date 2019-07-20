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

/// Abstract Page object to provide the default functionality for a concrete Page object.
/// * Attention: **None** of these methods require a custom implementation. Everything is provided with internal extensions.
public protocol PageObject: PageObjectWhen, PageObjectShould {

    /// Add a delay before continuing with the UI test flow.
    ///
    /// - Parameter delay: Seconds to add as delay
    /// - Returns: itself to use in a chain of calls
    @discardableResult
    func delay(_ delay: TimeInterval) -> Self

    /// Terminates an UI test
    static func terminate()
}

extension PageObject {
    @discardableResult
    public func delay(_ delay: TimeInterval) -> Self {
        Thread.sleep(forTimeInterval: delay)

        return self
    }
}

extension PageObject {
    public static func terminate() {
        XCUIApplication().terminate()
    }
}
