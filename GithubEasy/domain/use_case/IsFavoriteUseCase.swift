//
//  IsFavoriteUseCase.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

final class IsFavoriteUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(login: String) -> Bool {
        return repository.isUserFavorite(login: login)
    }
}
