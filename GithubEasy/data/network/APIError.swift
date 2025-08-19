//
//  APIError.swift
//  GithubEasy
//
//  Created by rabiakama  on 19.08.2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error?)
    case invalidResponse
    case decodingFailed(Error?)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Geçersiz URL."
        case .requestFailed:
            return "İstek başarısız oldu. İnternet bağlantınızı kontrol edin."
        case .invalidResponse:
            return "Sunucudan geçersiz bir yanıt alındı."
        case .decodingFailed:
            return "Veri işlenirken bir sorun oluştu."
        }
    }
}
