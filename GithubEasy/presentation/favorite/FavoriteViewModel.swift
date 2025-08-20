//
//  FavoriteViewModel.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

final class FavoriteViewModel {
    
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    
    var onStateChange: ((ViewState<[UserItemModel]>) -> Void)?
    
    private var allFavoriteUsers: [UserItemModel] = []
    
    init(getFavoritesUseCase: GetFavoritesUseCase, removeFavoriteUseCase: RemoveFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }
    
    private var displayedUsers: [UserItemModel] = [] {
        didSet {
            if displayedUsers.isEmpty {
                onStateChange?(.empty("Empty data"))
            } else {
                onStateChange?(.success(displayedUsers))
            }
        }
    }
    
    func fetchFavorites() {
        onStateChange?(.loading)
        let users = getFavoritesUseCase.execute()
        if users.isEmpty {
            self.allFavoriteUsers = []
            onStateChange?(.empty("Empty data"))
        } else {
            self.allFavoriteUsers = self.mapUsersToItemModels(users)
            self.displayedUsers = self.allFavoriteUsers
        }
    }
    
    func filterFavorites(with query: String) {
        if query.isEmpty {
            displayedUsers = allFavoriteUsers
            if allFavoriteUsers.isEmpty {
                onStateChange?(.empty("Empty data"))
            }
            return
        }
        
        displayedUsers = allFavoriteUsers.filter {
            $0.login.lowercased().contains(query.lowercased())
        }
    }
    
    func removeFavorite(user: UserItemModel) {
        removeFavoriteUseCase.execute(login: user.login)
        fetchFavorites()
    }
    
    private func mapUsersToItemModels(_ users: [User]) -> [UserItemModel] {
        return users.map { user in
            UserItemModel(login: user.login, avatarUrl: user.avatarUrl, profileUrl: user.profileUrl, isFavorite: true)
        }
    }
}
