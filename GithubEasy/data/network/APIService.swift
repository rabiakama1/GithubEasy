//
//  APIService.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

final class APIService {
    
    private let baseURL = "https://api.github.com/"
    
    private func performRequest<T: Decodable>(path: String, queryItems: [URLQueryItem]? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        
        var components = URLComponents(string: baseURL)
        components?.path = "/" + path
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                // Hata Kontrolü
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch let decodingError {
                    completion(.failure(.decodingFailed(decodingError)))
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Public Methods
    
    /// Verilen  sorgu ile kullanıcıları arar
    func searchUsers(query: String, completion: @escaping (Result<UserResponseDTO, APIError>) -> Void) {
        let path = "search/users"
        let queryItems = [URLQueryItem(name: "q", value: query)]
        
        performRequest(path: path, queryItems: queryItems, completion: completion)
    }
    
    /// Kullanıcının detayını getirir
    func getUserDetail(login: String, completion: @escaping (Result<UserDetailDTO, APIError>) -> Void) {
        let path = "users/\(login)"
        
        performRequest(path: path, completion: completion)
    }
}
