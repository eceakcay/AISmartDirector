//
//  NetworkManager.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

///modelleri internetten çekecek olan motor
import Foundation

enum NetworkError : Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url) //- Bir URL’ye istek atar- Sunucudan cevap bekler
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidURL
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}
