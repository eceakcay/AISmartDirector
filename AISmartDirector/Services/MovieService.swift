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
    // Yeni: Birden fazla genre ID'si ile film keşfetmek için
    func fetchMoviesByGenreIDs(_ ids: [Int]) async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let apiKey = "542ff9c1fdba20c0bc20d7698b98de01"
    private let baseURL = "https://api.themoviedb.org/3"
    
    // Mevcut popüler filmler fonksiyonun
    func fetchPopularMovies() async throws -> [Movie] {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=tr-TR&page=1"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let response: MovieResponse = try await NetworkManager.shared.fetch(url: url)
        return response.results
    }
    
    // Mevcut detay fonksiyonun
    func fetchMovieDetail(id: Int) async throws -> Movie {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=tr-TR"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        return try await NetworkManager.shared.fetch(url: url)
    }
    
    // MARK: - AI Destekli Tür Arama
    func fetchMoviesByGenreIDs(_ ids: [Int]) async throws -> [Movie] {
        // TMDB birden fazla türü virgül ile ayırarak kabul eder (Örn: 28,18)
        let genreString = ids.map { String($0) }.joined(separator: ",")
        
        // 'discover/movie' endpoint'ini kullanarak türe göre filtreleme yapıyoruz
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genreString)&language=tr-TR&sort_by=popularity.desc&page=1"
        
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let response: MovieResponse = try await NetworkManager.shared.fetch(url: url)
        return response.results
    }
}
