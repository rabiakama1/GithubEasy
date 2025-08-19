//
//  AddFavoriteUseCase.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

final class AddFavoriteUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(user: User) {
        repository.addFavorite(user: user)
    }
}
