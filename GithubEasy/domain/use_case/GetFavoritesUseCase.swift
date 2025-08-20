//
//  GetFavoritesUseCase.swift
//  GithubEasy
//
//  Created by rabiakama on 20.08.2025.
//

import Foundation

final class GetFavoritesUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [User] {
        return repository.getFavorites()
    }
}
