//
//  GTNTestUtils.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/7/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import XCTest

@testable import GootenCore

class GTNTestUtils: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGTNUtilsReplace() {
        let result = gtnUtilsReplace("-(test#123)!?", pattern: "[^a-zA-Z0-9]", replacementPattern: "");
        XCTAssert(result == "test123", "replace regex failed")
    }
    
    func testGTNConfig() {
        let config = GTNConfig();
        
        config.isInTestMode = false;
        config.recipeId = "87687607858747637";
        config.turnOffLogs = true;
        config.environment = .staging;
        config.countryCode = "ertg";
        config.languageCode = "sdfhl";
        config.currencyCode = "938479";
        config.showAllProducts = false;
        
        GTNConfig.sharedInstance.copy(from: config);
        XCTAssert(GTNConfig.sharedInstance.isEqual(config), "configs are not the same");
    }

}
