//
//  SearchUsersUseCase.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

class SearchUsersUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String, completion: @escaping (Result<[User], Error>) -> Void) {
        repository.searchUsers(query: query, completion: completion)
    }
}
