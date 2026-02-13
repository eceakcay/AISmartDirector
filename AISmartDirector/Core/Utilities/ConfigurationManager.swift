//
//  ConfigurationManager.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 13.02.2026.
//

import Foundation

enum ConfigurationManager {
    static var geminiAPIKey: String {
        // 1. Secrets.plist dosyasının yolunu bul
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            fatalError("Secrets.plist dosyası bulunamadı!")
        }
        
        // 2. Dosyayı oku ve sözlüğe çevir
        let plist = NSDictionary(contentsOfFile: filePath)
        
        // 3. Değeri çek
        guard let value = plist?.object(forKey: "GEMINI_API_KEY") as? String else {
            fatalError("Secrets.plist içinde GEMINI_API_KEY bulunamadı!")
        }
        
        return value
    }
}
