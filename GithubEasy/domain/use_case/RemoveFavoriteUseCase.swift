//
//  RemoveFavoriteUseCase.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

final class RemoveFavoriteUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(login: String) {
        repository.removeFavorite(login: login)
    }
}
