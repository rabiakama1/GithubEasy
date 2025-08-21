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
    let createdAt: String
    let htmlUrl:String
    let name:String
    let location:String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
        case htmlUrl = "html_url"
        case name
        case location
    }

    // DTO'yu Domain modeline çevirir
    func toDomain() -> UserDetail {
        return UserDetail(
            login: login,
            avatarUrl: avatarUrl,
            createdAt: createdAt,
            htmlUrl: htmlUrl,
            name:name,
            location:location
        )
    }
}
