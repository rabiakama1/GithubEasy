//
//  AppCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let apiService = APIService()
        let coreDataManager = CoreDataManager.shared
        let userRepository = DefaultUserRepository(apiService: apiService, coreData: coreDataManager)
        let searchUseCase = SearchUsersUseCase(repository: userRepository)
        let homeViewModel = HomeViewModel(searchUsersUseCase: searchUseCase,
                                          userRepository: userRepository)
        
        let homeVC = HomeViewController(viewModel: homeViewModel)
        
        // Callback → navigation işini Coordinator yapıyor
        homeVC.onUserSelected = { [weak self] user in
            self?.showDetail(for: user, repository: userRepository)
        }
        homeVC.onFavoritesTapped = { [weak self] in
            self?.showFavorites(repository: userRepository)
        }
        
        navigationController.viewControllers = [homeVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showDetail(for user: User, repository: UserRepositoryProtocol) {
        let detailViewModel = DetailViewModel(user: user, userRepository: repository)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func showFavorites(repository: UserRepositoryProtocol) {
        let favoritesViewModel = FavoriteViewModel(userRepository: repository)
        let favoritesVC = FavoriteViewController(viewModel: favoritesViewModel)
        navigationController.pushViewController(favoritesVC, animated: true)
    }
}
