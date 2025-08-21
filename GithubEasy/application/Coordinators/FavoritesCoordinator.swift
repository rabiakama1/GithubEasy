//
//  FavoritesCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 20.08.2025.
//

import UIKit

final class FavoritesCoordinator: BaseCoordinator {
    
    override func start() {
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
}
