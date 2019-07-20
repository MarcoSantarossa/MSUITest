import MSUITest
import XCTest

final class MainPage {
    typealias Element = MainAIP.Element
}

extension MainPage: PageObjectUIElementProvider, PageObject {
    func uiElement(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElement {
        let query = self.query(for: element, in: queryProvider)
        
        let identifier = MainAIP.elementIdentifier(for: element)
        return query[identifier]
    }
    
    private func query(for element: Element, in queryProvider: XCUIElementTypeQueryProvider) -> XCUIElementQuery {
        switch element {
        case .label:
            return queryProvider.staticTexts
        case .mainView:
            return queryProvider.otherElements
        }
    }
}

// MARK: - Given
extension MainPage {
    func givenPage() -> MainPage {
        XCUIApplication().launchTestMode()
        
        return self
    }
}
