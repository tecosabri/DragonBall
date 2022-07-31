//
//  NetworkModelTests.swift
//  DragonBallTests
//
//  Created by Ismael Sabri Pérez on 16/7/22.
//

import XCTest
@testable import DragonBall

enum ErrorMock: Error {
    case mockCase
}

class NetworkModelTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var sut: NetworkModel!
    
    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        
        sut = NetworkModel(urlSession: urlSessionMock)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLoginFailWithNoData() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .noData)
    }
    
    func testLoginFailWithError() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        urlSessionMock.error = ErrorMock.mockCase
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .other)
    }
    
    func testLoginFailWithErrorCodeNil() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = nil
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .errorCode(nil))
    }
    
    func testLoginFailWithErrorCode() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .errorCode(404))
    }
    
    func testLoginSuccessWithMockToken() {
        var error: NetworkError?
        var retrievedToken: String?
        
        //Given
        urlSessionMock.error = nil
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(withUser: "", andPassword: "") { token, networkError in
            retrievedToken = token
            error = networkError
        }
        
        //Then
        XCTAssertEqual(retrievedToken, "TokenString", "should have received a token")
        XCTAssertNil(error, "there should be no error")
    }
    
    func testGetHerosSuccess() {
        var error: NetworkError?
        var retrievedHeroes: [Hero]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getHeroesData(resourceName: "heroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getHeroes { heroes, networkError in
            error = networkError
            retrievedHeroes = heroes
        }
        
        //Then
        XCTAssertEqual(retrievedHeroes?.first?.id, "Hero ID", "should be the same hero as in the json file")
        XCTAssertNil(error, "there should be no error")
    }
    
    func testGetHerosSuccessWithNoHeroes() {
        var error: NetworkError?
        var retrievedHeroes: [Hero]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getHeroesData(resourceName: "noHeroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getHeroes { heroes, networkError in
            error = networkError
            retrievedHeroes = heroes
        }
        
        //Then
        XCTAssertNotNil(retrievedHeroes)
        XCTAssertEqual(retrievedHeroes?.count, 0)
        XCTAssertNil(error, "there should be no error")
    }
    
    // MARK: - TRANSFORMATIONS
    func testGetTransformationsSuccess() {
        var error: NetworkError?
        var retrievedTransformations: [Transformation]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getTransformationsData(resourceName: "transformations")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getTransformations(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { transformations, networkError in
            error = networkError
            retrievedTransformations = transformations
        }
        
        //Then
        XCTAssertEqual(retrievedTransformations?.first?.id, "17824501-1106-4815-BC7A-BFDCCEE43CC9", "should be the same transformation as in the json file")
        XCTAssertNil(error, "there should be no error")
    }
    
    func testGetTransformationsSuccessWithNoTransformations() {
        var error: NetworkError?
        var retrievedTransformations: [Transformation]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getTransformationsData(resourceName: "noTransformations")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getTransformations(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { transformations, networkError in
            error = networkError
            retrievedTransformations = transformations
        }
        
        //Then
        XCTAssertNotNil(retrievedTransformations)
        XCTAssertEqual(retrievedTransformations?.count, 0)
        XCTAssertNil(error, "there should be no error")
    }
}


extension NetworkModelTests {
    
    func getHeroesData(resourceName: String) -> Data? {
        let bundle = Bundle(for: NetworkModelTests.self)
        
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
    
    func getTransformationsData(resourceName: String) -> Data? {
        let bundle = Bundle(for: NetworkModelTests.self)
        
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
