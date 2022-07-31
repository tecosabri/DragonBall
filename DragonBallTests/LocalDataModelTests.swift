//
//  LocalDataModelTests.swift
//  DragonBallTests
//
//  Created by Ismael Sabri Pérez on 16/7/22.
//

import XCTest

import DragonBall
@testable import DragonBall


class LocalDataModelTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        LocalDataModel.deleteToken()
    }

    func testSaveToken() throws {
        // Given
        let token = "TokenKey"
        // When
        LocalDataModel.save(token: token)
        // Then
        XCTAssertNotNil(LocalDataModel.getToken(), "the token can't be nil")
        XCTAssertEqual(LocalDataModel.getToken(), "TokenKey", "the token doesn't match the stored token")
    }
    
    func testGetNilToken() throws {
        // Given
        var token: String?
        // When
        token = LocalDataModel.getToken()
        // Then
        XCTAssertNil(token, "the token must be nil")
    }

    func testDeleteToken() throws {
        // Given
        let token = "TokenKey"
        LocalDataModel.save(token: token)
        // When
        LocalDataModel.deleteToken()
        // Then
        XCTAssertNil(LocalDataModel.getToken(), "the token must be nil after deleting")
    }
    
    
}
