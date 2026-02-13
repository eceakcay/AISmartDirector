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
    func fetchMovieDetail(id: Int) async throws -> Movie
    func fetchMovies(by genre: String) async throws -> [Movie]
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
    
    func fetchMovieDetail(id: Int) async throws -> Movie {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=tr-TR"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let movie: Movie = try await NetworkManager.shared.fetch(url: url)
        return movie
    }
    
    func fetchMovies(by genre: String) async throws -> [Movie] {
        
        let genreMap: [String: Int] = [
            "action": 28,
            "drama": 18,
            "romance": 10749,
            "comedy": 35,
            "family": 10751,
            "thriller": 53,
            "horror": 27
        ]
        
        guard let genreId = genreMap[genre.lowercased()] else {
            return []
        }
        
        let urlString =
        "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genreId)&language=tr-TR&page=1"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let response: MovieResponse =
            try await NetworkManager.shared.fetch(url: url)
        
        return response.results
    }

}
