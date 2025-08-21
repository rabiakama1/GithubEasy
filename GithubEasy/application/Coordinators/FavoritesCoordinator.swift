//
//  FavoritesCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 20.08.2025.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let userRepository: UserRepositoryProtocol
    
    init(navigationController: UINavigationController, userRepository: UserRepositoryProtocol) {
        self.navigationController = navigationController
        self.userRepository = userRepository
    }
    
    func start() {
        let getFavoritesUseCase = GetFavoritesUseCase(repository: userRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: userRepository)
        
        let favoriteViewModel = FavoriteViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase
        )
        
        let favoritesVC = FavoriteViewController(viewModel: favoriteViewModel)
        
        favoritesVC.onUserSelected = { [weak self] userLogin in
            self?.showDetail(for: userLogin)
        }
        
        navigationController.viewControllers = [favoritesVC]
    }
    
    private func showDetail(for userLogin: String) {
        let getUserDetailUseCase = GetUserDetailsUseCase(repository: self.userRepository)
        let addFavoriteUseCase = AddFavoriteUseCase(repository: self.userRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: self.userRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: self.userRepository)
        
        let detailViewModel = DetailViewModel(
            login: userLogin,
            getUserDetailUseCase: getUserDetailUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        )
        
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
