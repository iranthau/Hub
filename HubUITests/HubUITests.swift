//  HubUITests.swift
//  HubUITests
//  Created by Irantha Rajakaruna on 3/12/2015.
//  Copyright © 2015 88Software. All rights reserved.

import XCTest

class HubUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateAccount() {
        let app = XCUIApplication()
        app.images["bg-img"].tap()
        app.buttons["Create Account"].tap()
        app.navigationBars["Terms and Conditions"].buttons["Agree"].tap()
        app.buttons["profile pic"].tap()
        app.sheets["Choose Image"].collectionViews.buttons["Gallary"].tap()
        
        let app2 = app
        app2.tables.buttons["Moments"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, 27 August 2014, 3:27 AM"].tap()
        app.textFields["First name"].tap()
        app.textFields["First name"].typeText("pip")
        app.textFields["Last name"].tap()
        app.textFields["Last name"].typeText("pip")
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("pip@pip.com")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("pip")
        app.secureTextFields["Confirm password"].tap()
        app.secureTextFields["Confirm password"].typeText("pip")
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        app.navigationBars["Create Account"].buttons["tick"].tap()
    }
}
