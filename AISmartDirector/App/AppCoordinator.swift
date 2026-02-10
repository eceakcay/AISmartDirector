//
//  AppCoordinator.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import Foundation
import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController
        )
        mainCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
