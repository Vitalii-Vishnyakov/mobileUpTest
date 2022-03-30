//
//  mobileUpTestTests.swift
//  mobileUpTestTests
//
//  Created by Виталий on 29.03.2022.
//

import XCTest
@testable import mobileUpTest



class mobileUpTestTests: XCTestCase {
    
    var testviewModel : ViewModel!
    var testmodel : Model!
    var mockLink = "https://oauth.vk.com/blank.html#access_token=871f63351c068a268e3a4dca2268da8d8566b377cd0320ca4440b0c6be73ef8ec2cd47dfb5dc059b56050&expires_in=86400&user_id=345270475"
    var exepctedToken = "871f63351c068a268e3a4dca2268da8d8566b377cd0320ca4440b0c6be73ef8ec2cd47dfb5dc059b56050"
    var expectedTokenAfterLogout = ""
    
    override func setUp() {
        testmodel = Model( )
        testmodel.isTest = true
        testviewModel = ViewModel(model: testmodel)
    }
    override func tearDown() {
        testmodel = nil
        testviewModel = nil
    }
    
    func testSeveToken( ){
        testmodel.saveToken(url: mockLink) { [unowned self ]result in
            switch result {
            case .success(let token):
                XCTAssertEqual(token, self.exepctedToken)
            case .failure(let error):
                XCTAssertEqual(Errors.faildToSaveToken, error)
            }
        }
    }
    
    func testGetToken ( ){
        XCTAssertTrue(testmodel.getToken().isValid)
        XCTAssertEqual(exepctedToken, testmodel.getToken().token)
    }
    
    func testLogout( ){
        testviewModel.logout { [unowned self ] _ in
            XCTAssertFalse(self.testviewModel.isTokenValid)
            XCTAssertFalse(self.testmodel.getToken().isValid)
            XCTAssertEqual(self.testmodel.getToken().token, expectedTokenAfterLogout)
        }
    }
}
