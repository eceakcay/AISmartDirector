//
//  AISmartDirectorTests.swift
//  AISmartDirectorTests
//
//  Created by Ece Akcay on 6.02.2026.
//

///"Action" yazısını verdiğimde, GenreMapper bana 28 ID’sini veriyor mu?
import XCTest
@testable import AISmartDirector // Uygulama modülüne erişim sağlar

final class GenreMapperTests: XCTestCase {
    
    func test_mapNamesToIds_returnsCorrectIdForAction() {
        // GIVEN: Elimizde "Action" kategori ismi var
        let input = ["Action"]
        
        // WHEN: Mapper fonksiyonunu çalıştırıyoruz
        let result = GenreMapper.mapNamesToIds(input)
        
        // THEN: Sonucun 28 içermesini bekliyoruz
        XCTAssertTrue(result.contains(28), "Action kategorisi 28 ID'sine sahip olmalıydı.")
    }
}
