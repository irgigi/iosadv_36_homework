//
//  NavigationTests.swift
//  NavigationTests


import XCTest
@testable import Navigation

enum MyError: Error {
    case myError
}

final class LoginTest: XCTestCase {
    
    var loginController: LogInViewController!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginController = LogInViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginController = nil
        try super.tearDownWithError()
    }
    
    func testValidLogin() throws {
        let logInspector = LoginInspector()
        let expectation = self.expectation(description: "Valid login expectation")
        
        logInspector.check("felix04", "1507") { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success, "login - true")
            case .failure:
                XCTFail("Valid login should not fail")
            }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testInvalidLogin() throws {
        let mocChecker = MockChecker()
        mocChecker.fakeResult = .success(false)
        
        let loginInspector = LoginInspector(checker: mocChecker)
        let expectation = self.expectation(description: "Invalid login expectation")
        loginInspector.check("invalidUser", "wrongPassword") { result in
            switch result {
            case .success(let success):
                XCTAssertFalse(success, "Invalid login")
            case .failure:
                XCTFail("Invalid login should not fail")
            }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testErrorLogin() throws {
        let mocChecker = MockChecker()
        mocChecker.fakeResult = .failure(MyError.myError)
        
        let loginInspector = LoginInspector(checker: mocChecker)
        let expectation = self.expectation(description: "Error login expectation")
        
        loginInspector.check("", "") { result in
            switch result {
            case .success(let success):
                XCTFail("Error login should not succeed")
                
            case .failure(let error):
                XCTAssertNotNil(error, "Error login should return an error")
            }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
