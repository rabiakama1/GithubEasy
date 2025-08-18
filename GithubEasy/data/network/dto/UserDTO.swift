//
//  UserDTO.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import Foundation

struct UserDTO: Codable {
    let userName: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case userName
        case avatarUrl = "avatar_url"
    }
    
    // DTO'yu Domain modeline çevirir
    func toDomain() -> User {
        return User(userName: userName, avatarUrl: avatarUrl)
    }
}
