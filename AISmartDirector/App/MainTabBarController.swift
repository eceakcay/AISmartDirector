//
//  MainTabBarController.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 12.02.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Dark theme
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 0.95)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemPink
        tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 1.0)
    }
    
    func setupViewControllers(home: UIViewController, favorites: UIViewController) {
        // Home tab
        home.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "film"),
            selectedImage: UIImage(systemName: "film.fill")
        )
        
        // Favorites tab
        favorites.tabBarItem = UITabBarItem(
            title: "Favoriler",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        viewControllers = [home, favorites]
    }
}
