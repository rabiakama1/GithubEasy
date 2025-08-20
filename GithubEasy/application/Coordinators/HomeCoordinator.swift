//
//  HomeCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 20.08.2025.
//

import UIKit

final class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let userRepository: UserRepositoryProtocol
    
    init(navigationController: UINavigationController, userRepository: UserRepositoryProtocol) {
        self.navigationController = navigationController
        self.userRepository = userRepository
    }
    
    func start() {
        let searchUseCase = SearchUsersUseCase(repository: userRepository)
        let addFavoriteUseCase = AddFavoriteUseCase(repository: userRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: userRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: userRepository)
        
        let homeViewModel = HomeViewModel(
            searchUsersUseCase: searchUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        )
        
        let homeVC = HomeViewController(viewModel: homeViewModel)
        
        homeVC.onUserSelected = { [weak self] userLogin in
            self?.showDetail(for: userLogin)
        }
        
        navigationController.viewControllers = [homeVC]
    }
    
    private func showDetail(for userLogin: String) {
        // Detay sayfasını push etme mantığı burada.
    }
}
