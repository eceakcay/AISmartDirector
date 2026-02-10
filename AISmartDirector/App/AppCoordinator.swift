//
//  AppCoordinator.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showHome()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showHome() {
        let viewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: viewModel)
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: false)
    }

    func showMovieDetail(movie: Movie) {
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
