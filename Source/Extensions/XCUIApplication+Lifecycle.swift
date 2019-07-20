import XCTest

extension XCUIApplication {
    public func launchTestMode(customArguments: [String]? = nil) {
        var args = [
            "-FIRDebugDisabled"
        ]
        if let customArguments = customArguments {
            args.append(contentsOf: customArguments)
        }
        launchArguments = args

        launch()
    }
}
