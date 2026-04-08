//
//  MovieServiceTests.swift
//  AISmartDirectorTests
//
//  Created by Ece Akcay on 8.04.2026.
//

import XCTest
@testable import AISmartDirector

final class MovieServiceTests: XCTestCase {
    
    var mockService: MockMovieService!

    override func setUp() {
        super.setUp()
        // Her testten önce taze bir mockService oluşturur
        mockService = MockMovieService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    func test_searchMovieByName_shouldBeCalledWithCorrectQuery() async throws {
        // GIVEN
        let expectedQuery = "Inception"
        
        // WHEN
        _ = try await mockService.searchMovieByName(query: expectedQuery)
        
        // THEN
        XCTAssertTrue(mockService.isSearchMovieByNameCalled, "Arama fonksiyonu tetiklenmedi!")
        XCTAssertEqual(mockService.lastSearchQuery, expectedQuery, "Servise gönderilen arama sorgusu yanlış!")
    }
}
