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
