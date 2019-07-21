# MSUITest 🤖🔎🐛

[![Twitter](https://img.shields.io/twitter/url/https/MarcoSantadev.svg?label=MarcoSantaDev&style=social)](https://twitter.com/MarcoSantaDev)

MSUITest is a library inspired by the classic [Gherkin syntax](http://docs.behat.org/en/v2.5/guides/1.gherkin.html) "Given-When-Then" written completely in Swift.

It's a wrapper of XCUITest and allows you to write human readable tests without wasting time reading Apple "documentation". 😌

## Content 📚

* [Why MSUITest](#why-msuitest)
* [Requirements](#requirements)
* [Installation](#installation)
* [Getting Started](#getting-started)
* [Advanced](Documentation/Advanced.md)
* [To Do](#to-do)
* [Disclaimer](#disclaimer)
* [License](#license)

## Why MSUITest

UI testing has often low priority in a project. It's slow and flaky tests. It's clear that we should try to cover with unit test as much code as possible. You could be even familiar with the test pyramid:

[![test pyramid](https://martinfowler.com/articles/practical-test-pyramid/testPyramid.png)](https://martinfowler.com/articles/practical-test-pyramid.html)

And I didn't even mention the hostile interface of XCUITest. 🤫

So, why this library? Why should we spend effort on UI testing ? Good question, my friend.

Unit test has a limit. It covers only isolated components. We need a way to test what our users are going to see in our iOS apps. UI testing helps to reduce tedious manual testing and regression tests.

Getting excited? That's good, because...MSUITesting comes to the rescue! 🎉

It provides a clean interface which allows everyone—even people not familiar with Swift—to read and understand the flow. We can stop wasting time googling how to fight XCUITest and focus in what matters. 😉

## Requirements

* iOS 10.0+
* Xcode 10.2+
* Swift 5+

## Installation

### Cocoapods

MSUITest is split in two main parts to provide then best solution at the right moment. You can take advantage of this in your **Podfile** with the following setup:

```
use_frameworks!

target 'YourAppTarget' do
  pod 'MSUITest/App'
end

target 'YouUITestTarget' do
  inherit! :search_paths
  pod 'MSUITest'
end

```

### Manually

Do you feel old school and you don't want black magic with dependency managers ? That's fine. You need few simple steps:

1. Download the project manually or through git submodules
2. Embed `MSUITest.xcodeproj` in your workspace
3. Add `MSUITest.framework` in `Embedded Binaries` and `Linked Frameworks and Libraries` of your iOS app.

## Getting Started

It's time to have fun.

**Note:**
I suggest to check the Example project to see different use cases and how I used the library for different situations.

### Set accessibility identifiers

XCUITest needs an accessibility identifier to find an UIKit element in the screen. Therefore, our first step is to set the identifiers of all our UIKit elements in our UIViewController:

```swift
final class HomeViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var registrationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = "home.mainView"
        titleLabel.accessibilityIdentifier = "home.titleLabel"
        subTitleLabel.accessibilityIdentifier = "home.subTitleLabel"
        loginButton.accessibilityIdentifier = "home.loginButton"
        registrationButton.accessibilityIdentifier = "home.registrationButton"
    }
}
```

### Create a Page Object

MSUITest uses the [page object pattern](https://martinfowler.com/bliki/PageObject.html). A page object is a helper class which provides functionalities to interact with a specific screen—like loading the screen, tapping a button and search for a label.

Let's create one in the **UI Test target**:

```swift
// 1
import MSUITest
import XCTest

final class HomePage {
    // 2
    typealias Element = String
}

extension HomePage: PageObjectUIElementProvider, PageObject {
    // 3
    func uiElement(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElement {
        let query = self.query(for: element, in: queryProvider)

        return query[element]
    }

    private func query(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElementQuery {
        // 4
        switch element {
        case "home.mainView":
            return queryProvider.otherElements
        case "home.titleLabel", "home.subTitle":
            return queryProvider.staticTexts
        case "home.loginButton", "home.registrationButton":
            return queryProvider.buttons
        default:
            fatalError("not found: \(element)")
        }
    }
}

// MARK: - Given
extension HomePage {
    // 5
    func givenPage() -> HomePage {
        XCUIApplication().launchTestMode()

        // 6
        return self
    }
}
```

1. Import the required frameworks.
2. Set the string literal as Element. See [AccessibilityIdentifierProvider (AIP)](Documentation/Advanced.md#AccessibilityIdentifierProvider-(AIP)) for a better approach.
3. Implement the protocol method to convert the identifier to a `XCUIElement`.
4. Create the query object to find the element. See the [Official Documentation](https://developer.apple.com/documentation/xctest/xcuielementtypequeryprovider) for a complete list.
5. Method to load launch the test. You can see [Launch specific view](Documentation/Advanced.md#launch-specific-view) for a better approach.
6. It's important to return `self` at the end of the method to allow a chain of functions. You'll see [later](#create-a-testcase) how the chain looks like.

### Create a TestCase

It's time to write the actual test. Let's create one in the **UI Test target**:

```swift
import XCTest

// 1
class HomeTests: XCTestCase {

    func test_whenLoadView_seeExpectedElements() {
        // 2
        HomePage()

            .givenPage()

            .thenIShouldSee(element: "home.mainView", timeout: 0.3)
            .thenIShouldSeeNavigationBar(text: "Home")
            .thenIShouldSee(element: "home.titleLabel", text: "Welcome")
            .thenIShouldSee(element: "home.subTitle", text: "Please login")
            .thenIShouldSee(element: "home.loginButton", text: "Log In")
            .thenIShouldSee(element: "home.registrationButton", text: "Register")
    }
}
```

1. Create a subclass of `XCTestCase`.
2. Instantiate the page object and have fun with a chain of "Given-When-Then" methods. Please read the code documentation for the full list of methods available.

## To Do

- [ ] Create static website with jazzy doc
- [ ] Add CI + Danger
- [ ] Add support for UICollectionView
- [ ] Fix Carthage build errors

## Disclaimer

* I'm the only maintainer of the library. I wasn't able to test all the UI cases and I would expect some bugs. If you find some, feel free to open an Issue and I would do my best to fix ASAP. I don't take responsibility for any problems caused by this library in a app in production.
* The code in the Example app is not supposed to be for production. Therefore, don't use it as reference for real app architecture, it should be improved.

## License

MSUITest is released under the MIT license. [See LICENSE](LICENSE) for details.
