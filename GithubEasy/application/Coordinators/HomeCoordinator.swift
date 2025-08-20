//
//  HomeCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 20.08.2025.
//

import UIKit

final class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let apiService = APIService()
        let userRepository = DefaultUserRepository(apiService: apiService, coreData: CoreDataManager.shared)
        
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
            self?.showDetail(for: userLogin, repository: userRepository)
        }
                
        navigationController.viewControllers = [homeVC]
    }
    
    private func showDetail(for userLogin: String, repository: UserRepositoryProtocol) {
        // Detay sayfasını push etme mantığı burada.
        // (Bir önceki cevaptaki gibi)
    }
}
