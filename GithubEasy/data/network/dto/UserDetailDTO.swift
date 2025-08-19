//
//  UserDetailDTO.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import Foundation

struct UserDetailDTO: Codable {
    let login: String
    let avatarUrl: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case date
    }

    // DTO'yu Domain modeline çevirir
    func toDomain() -> UserDetail {
        return UserDetail(
            login: login,
            avatarUrl: avatarUrl,
            date: date
        )
    }
}
