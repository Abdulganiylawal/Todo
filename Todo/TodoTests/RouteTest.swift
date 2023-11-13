//
//  RouteTest.swift
//  TodoTests
//
//  Created by Lawal Abdulganiy on 13/11/2023.
//

import XCTest
@testable import Todo
final class RouteTest: XCTestCase {
    private var model:NavigationManager!

    override func setUpWithError() throws {
        model = NavigationManager()
    }

    override func tearDownWithError() throws {
        model = nil
    }
    
    func testRouteShouldBeEmptyWhenInitialized(){
        XCTAssertEqual(model.routes.isEmpty, true)
    }
    
    func testRouteShouldHaveAnElementWhenPushedFunctionIsCalled(){
        model.push(to: .SettingsView)
        XCTAssertEqual(model.routes.count >= 1, true, "Route should have one element")
    }

    func testRouteShouldHave2ElementWhenPushedFunctionIsCalledTwice(){
        model.push(to: .SettingsView)
        model.push(to: .groupTaskView(selector: .all))
        XCTAssertEqual(model.routes.count >= 2, true, "Route should have two element")
    }
    
    func testRouteShouldHaveNoElementWhenGoBackFunctionIsCalled(){
        model.push(to: .SettingsView)
        model.goBack()
        XCTAssertEqual(model.routes.count == 0, true, "Route should be empty")
    }
  

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
