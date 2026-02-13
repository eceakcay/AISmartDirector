//
//  HomeViewModel.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var onStateChange: ((HomeViewState) -> Void)? { get set }
    func loadMovies() async
    func searchMoviesByMood(text: String) async // Yeni: AI destekli arama
}

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    
    var onStateChange: ((HomeViewState) -> Void)?
    private let movieService: MovieServiceProtocol
    private let aiService: AIServiceProtocol // Yeni: AI Servisi eklendi
    
    // Bağımlılıkları init içinde enjekte ediyoruz
    init(service: MovieServiceProtocol = MovieService(),
         aiService: AIServiceProtocol = AIService()) {
        self.movieService = service
        self.aiService = aiService
    }
    
    // Varsayılan popüler filmleri yükler
    func loadMovies() async {
        onStateChange?(.loading)
        do {
            let movies = try await movieService.fetchPopularMovies()
            onStateChange?(.loaded(movies))
        } catch {
            onStateChange?(.error("Filmler yüklenemedi"))
        }
    }
    
    // MARK: - AI Destekli Arama
    func searchMoviesByMood(text: String) async {
        guard !text.isEmpty else { return }
        
        onStateChange?(.loading)
        
        do {
            // 1. Adım: AI'dan tür isimlerini al (Örn: ["Drama", "Action"])
            let genreNames = try await aiService.extractCategories(from: text)
            print("🤖 AI Türleri Belirledi: \(genreNames)")
            
            // 2. Adım: İsimleri TMDB ID'lerine çevir (Örn: [18, 28])
            let genreIds = GenreMapper.mapNamesToIds(genreNames)
            
            // 3. Adım: Eğer ID bulunamazsa hata döndür, bulunursa filmleri çek
            if genreIds.isEmpty {
                onStateChange?(.error("İsteğine uygun film türü bulunamadı."))
                return
            }
            
            // 4. Adım: MovieService'ten bu ID'lere göre keşif (discover) yap
            // Not: MovieService içine fetchMoviesByGenreIDs metodunu eklemelisin
            let recommendedMovies = try await movieService.fetchMoviesByGenreIDs(genreIds)
            
            onStateChange?(.loaded(recommendedMovies))
            
        } catch {
            print("🚨 AI Arama Hatası: \(error)")
            onStateChange?(.error("Üzgünüm, sana uygun filmleri şu an bulamıyorum."))
        }
    }
}
