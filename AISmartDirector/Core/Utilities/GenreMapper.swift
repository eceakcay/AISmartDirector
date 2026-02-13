//
//  GenreMapper.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 13.02.2026.
//

import Foundation

enum GenreMapper {
    // TMDB Resmi Tür Listesi
    private static let genres: [String: Int] = [
        "Action": 28,
        "Adventure": 12,
        "Animation": 16,
        "Comedy": 35,
        "Crime": 80,
        "Documentary": 99,
        "Drama": 18,
        "Family": 10751,
        "Fantasy": 14,
        "History": 36,
        "Horror": 27,
        "Music": 10402,
        "Mystery": 9648,
        "Romance": 10749,
        "Science Fiction": 878,
        "Thriller": 53,
        "War": 10752,
        "Western": 37
    ]
    
    /// AI'dan gelen isim dizisini TMDB ID dizisine çevirir
    static func mapNamesToIds(_ names: [String]) -> [Int] {
        return names.compactMap { name in
            // AI bazen "Action " (boşluklu) veya "action" (küçük harf) döndürebilir, normalize ediyoruz.
            let normalizedName = name.trimmingCharacters(in: .whitespaces).capitalized
            return genres[normalizedName]
        }
    }
}
