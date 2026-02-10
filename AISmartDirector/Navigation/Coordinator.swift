//
//  Coordinator.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

final class HomeCoordinator: Coordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: viewModel)
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: false)
    }

    func showMovieDetail(movie: Movie) {
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

