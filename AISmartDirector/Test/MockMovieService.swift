//
//  MockMovieService.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 8.04.2026.
//

import Foundation
@testable import AISmartDirector

//MOCK SERVİCE
final class MockMovieService: MovieServiceProtocol {
    
    // Fonksiyonların çağrılıp çağrılmadığını kontrol etmek için "bayraklar" (flags)
    var isFetchPopularMoviesCalled = false
    var isSearchMovieByNameCalled = false
    var lastSearchQuery: String? // Hangi kelimenin arandığını test etmek için
    
    // Sahte bir film verisi hazırlayalım
    let mockMovie = Movie(id: 1,title: "Test Filmi",overview: "Test Açıklaması",posterPath: nil,releaseDate: "2023-01-01",voteAverage: 10.0)
    
    func fetchPopularMovies() async throws -> [Movie] {
        isFetchPopularMoviesCalled = true
        return [mockMovie]
    }

    func fetchMovieDetail(id: Int) async throws -> Movie {
        return mockMovie
    }

    func fetchMoviesByGenreIDs(_ ids: [Int]) async throws -> [Movie] {
        return [mockMovie]
    }

    func searchMovieByName(query: String) async throws -> [Movie] {
        isSearchMovieByNameCalled = true
        lastSearchQuery = query // Gelen sorguyu kaydediyoruz
        return [mockMovie]
    }
}
