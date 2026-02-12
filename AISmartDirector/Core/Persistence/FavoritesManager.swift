//
//  FavoritesManager.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 12.02.2026.
//

import Foundation

protocol FavoritesManagerProtocol {
    func isFavorite(id: Int) -> Bool
    func toggleFavorite(id: Int)
    func getAllFavorites() -> [Int]
}

final class FavoritesManager: FavoritesManagerProtocol {
    
    static let shared = FavoritesManager()
    
    private let key = "favorite_movie_ids"
    
    private init() {}
    
    func getAllFavorites() -> [Int] {
        UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
    
    func isFavorite(id: Int) -> Bool {
        getAllFavorites().contains(id)
    }
    
    func toggleFavorite(id: Int) {
        if isFavorite(id: id) {
            remove(id: id)
        } else {
            add(id: id)
        }
    }
    
    func add(id: Int) {
        var favorites = getAllFavorites()
        guard !favorites.contains(id) else { return }
        
        favorites.append(id)
        UserDefaults.standard.set(favorites, forKey: key)
    }
    
    func remove(id: Int) {
        var favorites = getAllFavorites()
        favorites.removeAll { $0 == id }
        UserDefaults.standard.set(favorites, forKey: key)
    }
    
}
