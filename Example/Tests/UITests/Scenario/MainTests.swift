//  Copyright © 2019 Marco Santarossa. All rights reserved.
//

import XCTest

class MainTests: XCTestCase {

    func test_whenLoadView_seeExpectedElements() {
        MainPage()
            .givenPage()
        
            .thenIShouldSee(element: .mainView)
    }
}
