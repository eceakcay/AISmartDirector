//
//  MovieDetailViewModel.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 17.02.2026.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var movieTitle: String { get }
    var overview: String { get }
    var releaseDate: String { get }
    var rating: String { get }
    var posterURL: URL? { get }
    var isFavorite: Bool { get }
    
    func toggleFavorite()
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    private let movie: Movie
    private let favoritesManager = FavoritesManager.shared
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: - Properties
    var movieTitle: String { movie.title }
    
    var overview: String {
        movie.overview ?? "Bu film için henüz bir açıklama eklenmemiş."
    }
    
    var posterURL: URL? { movie.posterURL }
    
    var releaseDate: String {
        guard let releaseDate = movie.releaseDate else { return "" }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if let date = df.date(from: releaseDate) {
            df.locale = Locale(identifier: "tr_TR")
            df.dateFormat = "dd MMMM yyyy"
            return "📅 " + df.string(from: date)
        }
        return releaseDate
    }
    
    var rating: String {
        guard let vote = movie.voteAverage else { return "0.0" }
        return String(format: "%.1f", vote)
    }
    
    var isFavorite: Bool {
        favoritesManager.isFavorite(id: movie.id)
    }
    
    // MARK: - Actions
    func toggleFavorite() {
        favoritesManager.toggleFavorite(id: movie.id)
    }
}
