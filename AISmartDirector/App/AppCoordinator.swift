//
//  AppCoordinator.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let window: UIWindow
    private var tabBarController: MainTabBarController?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        setupTabBar()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setupTabBar() {
        // Tab Bar Controller oluştur
        let tabBarController = MainTabBarController()
        tabBarController.coordinator = self
        self.tabBarController = tabBarController
        
        // 🏠 Home ViewController
        let homeViewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeVC.coordinator = self
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        // ❤️ Favorites ViewController
        let favoritesVC = FavoritesViewController()
        favoritesVC.coordinator = self
        let favoritesNavController = UINavigationController(rootViewController: favoritesVC)
        
        // Tab Bar'a ekle
        tabBarController.setupViewControllers(home: homeNavController, favorites: favoritesNavController)
    }
    
    // MARK: - Navigation
    func showMovieDetail(movie: Movie) {
        let detailVC = MovieDetailViewController(movie: movie)
        
        // Aktif tab'ın navigation controller'ını bul
        if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
            selectedNav.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Deeplink
    func handleDeeplink(_ url: URL) {
        guard
            url.scheme == "aismartdirector",
            url.host == "movie",
            let movieId = Int(url.lastPathComponent)
        else {
            return
        }
        
        showMovieDetailById(movieId)
    }
    
    private func showMovieDetailById(_ movieId: Int) {
        Task {
            do {
                let movie = try await MovieService().fetchMovieDetail(id: movieId)
                
                // Home tab'ına geç ve detayı göster
                tabBarController?.selectedIndex = 0
                
                if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
                    // Root'a dön
                    selectedNav.popToRootViewController(animated: false)
                    // Detay sayfasını aç
                    let detailVC = MovieDetailViewController(movie: movie)
                    selectedNav.pushViewController(detailVC, animated: true)
                }
            } catch {
                print("DEEPLINK ERROR:", error)
            }
        }
    }
    
    // MARK: - AI Recommendation
    func generateAIRecommendation(prompt: String) {
        let aiService = AIService()
        let movieService = MovieService()

        Task {
            do {
                let categories = try await aiService.extractCategories(from: prompt)
                let movies = try await fetchMovies(for: categories, movieService: movieService)
                
                // ✅ Prompt'u da geç
                showAIResult(prompt: prompt, movies: movies)

            } catch {
                print("AI ERROR:", error)
            }
        }
    }

    private func showAIResult(prompt: String, movies: [Movie]) { // ✅ Param ekledik
        let vc = AIResultViewController(
            prompt: prompt,
            movies: movies
        )

        vc.coordinator = self

        if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
            selectedNav.pushViewController(vc, animated: true)
        }
    }
    
    
    private func fetchMovies(
        for categories: [String],
        movieService: MovieService
    ) async throws -> [Movie] {
        
        // 1. Kategorileri ID'lere çeviriyoruz
        let genreIds = GenreMapper.mapNamesToIds(categories)
        
        // 2. Eğer ID bulunamazsa boş dön
        guard !genreIds.isEmpty else { return [] }
        
        // 3. MovieService içindeki yeni metodu çağırıyoruz
        // Not: MovieService içinde bu metodun adının 'fetchMoviesByGenreIDs' olduğundan emin ol
        return try await movieService.fetchMoviesByGenreIDs(genreIds)
    }
    
    
    func showAIPrompt() {
        let vc = AIPromptViewController()
        vc.coordinator = self
        
        if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
            selectedNav.pushViewController(vc, animated: true)
        }
    }
}
