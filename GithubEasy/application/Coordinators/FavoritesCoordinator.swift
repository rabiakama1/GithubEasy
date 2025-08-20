//
//  FavoritesCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 20.08.2025.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userRepository = DefaultUserRepository(apiService: APIService(), coreData: CoreDataManager.shared)
        let getFavoritesUseCase = GetFavoritesUseCase(repository: userRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: userRepository)
        
      /*  let favoritesViewModel = FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase
        )
        
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
        
        favoritesVC.onUserSelected = { [weak self] userLogin in
            self?.showDetail(for: userLogin, repository: userRepository)
        }*/
        
        //navigationController.viewControllers = [favoritesVC]
    }
    
    private func showDetail(for userLogin: String, repository: UserRepositoryProtocol) {
    }
}
