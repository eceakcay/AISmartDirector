//
//  MainCoordinator.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // 1. Önce servis katmanını oluşturuyoruz (isteğe bağlı, init içinde varsayılan olarak var)
        let movieService = MovieService()
        
        // 2. ViewModel'i oluşturuyoruz ve servisi içine enjekte ediyoruz
        let viewModel = HomeViewModel(service: movieService)
        
        // 3. ViewController'ı oluştururken hazırladığımız viewModel'i veriyoruz
        let homeVC = HomeViewController(viewModel: viewModel)
        
        navigationController.pushViewController(homeVC, animated: true)
    }
    
}
