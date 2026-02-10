//
//  MovieService.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

///Bu servis, TMDB API ile NetworkManager'ın arasında bir köprü kuracak.
///hangi veriyi çekiyoruz -> popülerfilmler
import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies() async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let apiKey = "542ff9c1fdba20c0bc20d7698b98de01"
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchPopularMovies() async throws-> [Movie] {
        
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=tr-TR&page=1"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let response: MovieResponse = try await NetworkManager.shared.fetch(url: url)
        
        return response.results
    }
}
