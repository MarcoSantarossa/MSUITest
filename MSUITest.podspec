Pod::Spec.new do |spec|

  spec.name         = "MSUITest"
  spec.version      = "1.0.0"
  spec.summary      = "A Swift XCUITest wrapper inspired by Gherkin syntax."

  spec.description  = <<-DESC
                   A XCUITest wrapper written in Swift inspired by the Gherkin syntax to allow everyone to write human readable UI tests in a clean way.
                    DESC

  spec.homepage     = "https://github.com/MarcoSantarossa/MSUITest"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = "Marco Santarossa"
  spec.social_media_url   = "https://twitter.com/MarcoSantaDev"

  spec.source       = { :git => "https://github.com/MarcoSantarossa/MSUITest.git", :tag => "#{spec.version}" }

  spec.subspec "Core" do |ss|
    ss.ios.deployment_target = '10.0'
    ss.source_files  = "Source/Core/**/*.swift"
    ss.framework  = "XCTest"
  end

  spec.subspec "App" do |ss|
    ss.ios.deployment_target = '10.0'
    ss.source_files  = ["Source/AIP/**/*.swift", "Source/Core/LaunchArguments/UITestLaunchArguments.swift"]
  end
end
