//
//  AlbumGeneratorUITests.swift
//  AlbumGeneratorUITests
//
//  Created by Erik James on 2/16/21.
//

import XCTest

class AlbumGeneratorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let app = XCUIApplication()
        app.launchArguments = ["uiTestMode"]
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImagesLoad() throws {
        // UI tests must launch the application that they test.
        let image = XCUIApplication().windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element
        
        
        let myImage = XCUIApplication().images["albumImage"]
        let screenshotBefore = myImage.screenshot()
        
        image.tap()
        
        //...
        //do some actions that change the image being displayed
        //...
        let screenshotAfter = myImage.screenshot()

        //Validating that the image changed as intended
        XCTAssertNotEqual(screenshotBefore.pngRepresentation, screenshotAfter.pngRepresentation)
    }

    func testBandNameLoads() {
        let bandName = XCUIApplication().staticTexts["bandLabel"]
        let label = bandName.label.va as? UILabel
       
        XCTAssertEqual(bandName.label, "This is a test")
    }
}
