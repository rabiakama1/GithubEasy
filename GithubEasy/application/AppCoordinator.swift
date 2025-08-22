//
//  AppCoordinator.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    
    private var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let apiService = APIService()
        let coreDataManager = CoreDataManager()
        let userRepository = DefaultUserRepository(apiService: apiService, coreData: coreDataManager)
        let tabBarController = MainTabBarController()
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController, userRepository: userRepository)
        
        let favoritesNavigationController = UINavigationController()
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController, userRepository: userRepository)
        
        childCoordinators = [homeCoordinator, favoritesCoordinator]
        homeCoordinator.start()
        favoritesCoordinator.start()
        
        tabBarController.viewControllers = [homeNavigationController, favoritesNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
