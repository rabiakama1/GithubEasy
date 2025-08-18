//
//  DefaultUserRepository.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

class DefaultUserRepository: UserRepositoryProtocol {
    
    private let apiService: APIService
    private let coreDataManager = CoreDataManager.shared
        
    // MARK: - Favorites
    func searchUsers(query: String, completion: @escaping (Result<[User], any Error>) -> Void) {
        
    }
    
    func getUserDetail(username: String, completion: @escaping (Result<UserDetail, any Error>) -> Void) {
        
    }
    
    func addFavorite(user: User) {
        coreDataManager.addFavorite(name: user.userName, avatarUrl: user.avatarUrl)
    }
    
    func removeFavorite(login: String) {
        coreDataManager.deleteFavorite(login: login)
    }
    
    func getFavorites() -> [User] {
        let favoriteEntities = coreDataManager.fetchAllFavorites()
        return favoriteEntities.map { User(userName: $0.userName ?? "", avatarUrl: $0.avatarURL ?? "") }
    }
    
    func isUserFavorite(login: String) -> Bool {
        return coreDataManager.isFavorite(login: login)
    }
}
