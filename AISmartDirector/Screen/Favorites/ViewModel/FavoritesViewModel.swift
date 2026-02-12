//
//  FavoritesViewModel.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 12.02.2026.
//

import Foundation

enum FavoritesState {
    case idle
    case loading
    case loaded([Movie])
    case empty
    case error(String)
}

protocol FavoritesViewModelProtocol {
    var onStateChange: ((FavoritesState) -> Void)? { get set }
    func loadFavorites()
}

final class FavoritesViewModel: FavoritesViewModelProtocol {

    var onStateChange: ((FavoritesState) -> Void)?

    private let movieService: MovieServiceProtocol
    private let favoritesManager: FavoritesManager

    init(
        movieService: MovieServiceProtocol = MovieService(),
        favoritesManager: FavoritesManager = FavoritesManager.shared
    ) {
        self.movieService = movieService
        self.favoritesManager = favoritesManager
    }

    func loadFavorites() {
        let ids = favoritesManager.getAllFavorites()

        guard !ids.isEmpty else {
            onStateChange?(.empty)
            return
        }

        onStateChange?(.loading)

        Task {
            do {
                let movies = try await fetchMovies(for: ids)
                onStateChange?(.loaded(movies))
            } catch {
                onStateChange?(.error("Favoriler yüklenemedi"))
            }
        }
    }

    private func fetchMovies(for ids: [Int]) async throws -> [Movie] {
        try await withThrowingTaskGroup(of: Movie.self) { group in

            for id in ids {
                group.addTask {
                    try await self.movieService.fetchMovieDetail(id: id)
                }
            }

            var movies: [Movie] = []

            for try await movie in group {
                movies.append(movie)
            }

            return movies
        }
    }
}

