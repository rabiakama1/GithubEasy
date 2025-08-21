//
//  BaseCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 22.08.2025.
//

import UIKit

class BaseCoordinator: Coordinator {
    let navigationController: UINavigationController
    let userRepository: UserRepositoryProtocol
    
    init(navigationController: UINavigationController, userRepository: UserRepositoryProtocol) {
        self.navigationController = navigationController
        self.userRepository = userRepository
    }
    
    func showDetail(for userLogin: String) {
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
    
    func start() {
        fatalError("Must be overridden")
    }
}
