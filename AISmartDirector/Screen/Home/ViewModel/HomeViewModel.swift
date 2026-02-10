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
}

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    
    var onStateChange: ((HomeViewState) -> Void)?
    private let movieService: MovieServiceProtocol
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.movieService = service
    }
    
    func loadMovies() async {
        onStateChange?(.loading)
        
        do {
            let movies = try await movieService.fetchPopularMovies()
            onStateChange?(.loaded(movies))
        } catch {
            onStateChange?(.error("Filmler yüklenemedi"))
        }
    }
}
