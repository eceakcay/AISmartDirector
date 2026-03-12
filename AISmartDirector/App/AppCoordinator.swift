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
        let tabBarController = MainTabBarController()
        tabBarController.coordinator = self
        self.tabBarController = tabBarController
        
        // 🏠 Home ViewController (MVVM)
        let homeViewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeVC.coordinator = self
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        // ❤️ Favorites ViewController
        let favoritesVC = FavoritesViewController()
        favoritesVC.coordinator = self
        let favoritesNavController = UINavigationController(rootViewController: favoritesVC)
        
        tabBarController.setupViewControllers(home: homeNavController, favorites: favoritesNavController)
    }
    
    // MARK: - Navigation
    func showMovieDetail(movie: Movie) {
        // ✅ MVVM: Önce ViewModel oluşturulur, sonra ViewController'a enjekte edilir
        let viewModel = MovieDetailViewModel(movie: movie)
        let detailVC = MovieDetailViewController(viewModel: viewModel)
        
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
                
                tabBarController?.selectedIndex = 0
                
                if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
                    selectedNav.popToRootViewController(animated: false)
                    
                    // ✅ MVVM: Deeplink akışında da ViewModel kullanıyoruz
                    let viewModel = MovieDetailViewModel(movie: movie)
                    let detailVC = MovieDetailViewController(viewModel: viewModel)
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
                showAIResult(prompt: prompt, movies: movies)
            } catch {
                print("AI ERROR:", error)
            }
        }
    }

    private func showAIResult(prompt: String, movies: [Movie]) {
        let vc = AIResultViewController(
            prompt: prompt,
            movies: movies
        )
        vc.coordinator = self

        if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
            selectedNav.pushViewController(vc, animated: true)
        }
    }
    
    private func fetchMovies(for categories: [String],movieService: MovieService) async throws -> [Movie] {
        
        // 1. Kategorileri ID'lere çeviriyoruz
        let genreIds = GenreMapper.mapNamesToIds(categories)
        guard !genreIds.isEmpty else { return [] }
        
        // 2. TaskGroup ile paralel istekleri başlatıyoruz
        return try await withThrowingTaskGroup(of: [Movie].self) { group in
            
            for id in genreIds {
                // Her bir tür için bağımsız bir görev (task) ekliyoruz
                group.addTask {
                    // MovieService içindeki metodun tekli bir ID listesi aldığından emin ol
                    return try await movieService.fetchMoviesByGenreIDs([id])
                }
            }
            
            var allMovies: [Movie] = []
            
            // Görevler bittikçe sonuçları topluyoruz
            for try await movies in group {
                allMovies.append(contentsOf: movies)
            }
            
            // 3. Veri Temizliği: Aynı film farklı kategorilerde olabilir, mükerrer kayıtları sil
            // Not: Movie modelinin Hashable olması gerekir.
            let uniqueMovies = Array(Set(allMovies))
            
            // Popülerliğe göre sıralayıp ilk 20 tanesini dönelim
            return uniqueMovies.sorted(by: { $0.voteAverage ?? 0 > $1.voteAverage ?? 0 }).prefix(20).map { $0 }
        }
    }
    
    func showAIPrompt() {
        let vc = AIPromptViewController()
        vc.coordinator = self
        
        if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
            selectedNav.pushViewController(vc, animated: true)
        }
    }
}
