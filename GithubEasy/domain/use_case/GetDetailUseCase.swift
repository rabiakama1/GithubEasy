//
//  GetDetailUseCase.swift
//  GithubEasy
//
//  Created by rabiakama on 21.08.2025.
//

final class GetUserDetailsUseCase {
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(username: String, completion: @escaping (Result<UserDetail, Error>) -> Void) {
        repository.getUserDetail(login: username, completion: completion)
    }
}
