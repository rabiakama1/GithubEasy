//
//  UserDTO.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import Foundation

struct UserDTO: Codable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
    
    // DTO'yu Domain modeline çevirir
    func toDomain() -> User {
        return User(login: login, avatarUrl: avatarUrl, profileUrl: htmlUrl)
    }
}
