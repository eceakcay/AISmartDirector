//
//  AIService.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 12.02.2026.
//

import Foundation

enum AIError: LocalizedError {
    case serviceBusy    // 503 Hatası için
    case invalidResponse
    case modelNotFound
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .serviceBusy:
            return "Yapay zeka şu an çok yoğun. Lütfen birkaç saniye sonra tekrar deneyin."
        case .invalidResponse:
            return "Beklenmedik bir yanıt alındı."
        case .modelNotFound:
            return "Uygun yapay zeka modeli bulunamadı."
        case .unknown(let message):
            return message
        }
    }
}


protocol AIServiceProtocol {
    func extractCategories(from prompt: String) async throws -> [String]
}

final class AIService: AIServiceProtocol {
    
    private let apiKey = ConfigurationManager.geminiAPIKey
    private let baseUrl = "https://generativelanguage.googleapis.com"

    func extractCategories(from prompt: String) async throws -> [String] {
        print("\n--- 🤖 AI SÜRECİ BAŞLADI ---")
        
        do {
            // 1. ADIM: Çalışan bir model bul
            let activeModel = try await getActiveModelName()
            print("🎯 Seçilen Aktif Model: \(activeModel)")
            
            // 2. ADIM: İsteği Hazırla
            let url = URL(string: "\(baseUrl)/v1beta/models/\(activeModel):generateContent?key=\(apiKey)")!
            
            let fullPrompt = """
            Return ONLY a JSON array of movie genres based on: "\(prompt)". 
            Example: ["Drama", "Action"]. No explanations.
            """
            
            let body: [String: Any] = [
                "contents": [["parts": [["text": fullPrompt]]]],
                "generationConfig": ["temperature": 0.1]
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // 3. ADIM: İsteği At ve Yanıtı Logla
            print("📡 API İsteği Gönderiliyor...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Response alınamadı"])
            }
            
            print("📊 Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                if httpResponse.statusCode == 503 {
                    print("⚠️ Sunucu Meşgul (503)")
                    throw AIError.serviceBusy // İşte özel hatamız!
                }
                
                let errorJson = String(data: data, encoding: .utf8) ?? "Detay yok"
                print("❌ API HATASI: \(errorJson)")
                throw AIError.unknown("API Hatası: \(httpResponse.statusCode)")
            }
            
            // 4. ADIM: Parse Et
            return try parseResponse(data)
            
        } catch {
            print("🚨 KRİTİK HATA: \(error.localizedDescription)")
            throw error
        }
    }

    private func getActiveModelName() async throws -> String {
        print("🔍 Uygun model aranıyor...")
        let url = URL(string: "\(baseUrl)/v1beta/models?key=\(apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let models = json["models"] as? [[String: Any]] else {
            throw NSError(domain: "AIService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Modeller listelenemedi"])
        }
        
        // İsmi içinde 'gemini' geçen ve içerik üretebilen ilk modeli al
        let model = models.first { model in
            let name = model["name"] as? String ?? ""
            let methods = model["supportedGenerationMethods"] as? [String] ?? []
            return name.contains("gemini") && methods.contains("generateContent")
        }
        
        guard let fullPath = model?["name"] as? String else {
            return "gemini-1.5-flash" // Fallback
        }
        
        return fullPath.replacingOccurrences(of: "models/", with: "")
    }

    private func parseResponse(_ data: Data) throws -> [String] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let candidates = json?["candidates"] as? [[String: Any]]
        let content = candidates?.first?["content"] as? [String: Any]
        let parts = content?["parts"] as? [[String: Any]]
        let text = parts?.first?["text"] as? String ?? ""
        
        print("🤖 AI Yanıtı: \(text)")
        
        let cleanedText = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let cleanData = cleanedText.data(using: .utf8) else {
            throw NSError(domain: "AIService", code: -3, userInfo: [NSLocalizedDescriptionKey: "JSON veriye dönüştürülemedi"])
        }
        
        let result = try JSONDecoder().decode([String].self, from: cleanData)
        print("✅ Başarıyla Ayrıştırıldı: \(result)")
        return result
    }
}
