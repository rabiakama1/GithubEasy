//
//  DefaultUserRepository.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

class DefaultUserRepository: UserRepositoryProtocol {
    
    private let apiService: APIService
    private var coreDataManager = CoreDataManager.shared
    
    init(apiService: APIService, coreData: CoreDataManager) {
         self.apiService = apiService
         self.coreDataManager = coreData
     }
    
    // MARK: - Network Operations
    
    func searchUsers(query: String, page: Int, completion: @escaping (Result<[User], Error>) -> Void) {
           apiService.searchUsers(query: query, page: page) { result in
               switch result {
               case .success(let responseDTO):
                   let users = responseDTO.items.map { $0.toDomain() }
                   completion(.success(users))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    func getUserDetail(login: String, completion: @escaping (Result<UserDetail, Error>) -> Void) {
        apiService.getUserDetail(login: login) { result in
            switch result {
            case .success(let detailDTO):
                let userDetail = detailDTO.toDomain()
                completion(.success(userDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Favorites Operations
    
    func addFavorite(user: User) {
        coreDataManager.addFavorite(name: user.login, avatarUrl: user.avatarUrl)
    }
    
    func removeFavorite(login: String) {
        coreDataManager.deleteFavorite(login: login)
    }
    
    func getFavorites() -> [User] {
        let favoriteEntities = coreDataManager.fetchAllFavorites()
        return favoriteEntities.map { User(login: $0.login ?? "", avatarUrl: $0.avatarURL ?? "", profileUrl: $0.htmlURL ?? "") }
    }
    
    func isUserFavorite(login: String) -> Bool {
        return coreDataManager.isFavorite(login: login)
    }
}
