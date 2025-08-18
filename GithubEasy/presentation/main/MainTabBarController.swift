//
//  MainTabBarController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupTabs()
        setupTabs()
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .systemGray
        self.delegate = self
         updateCartBadge()
    }
    
    @objc private func updateCartBadge() {
        let cartCount = CoreDataManager.shared.getCartItemCount()
        if let tabItems = tabBar.items, tabItems.count > 1 {
            let cartTab = tabItems[1]
            if cartCount > 0 {
                cartTab.badgeValue = "\(cartCount)"
                cartTab.badgeColor = .systemRed
            } else {
                cartTab.badgeValue = nil
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTabs() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let favoriteVC = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
        let detailVC = DetailViewController(nibName: "HomeViewController", bundle: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        favoriteNav.tabBarItem = UITabBarItem(title: "Favori", image: UIImage(systemName: "star"), tag: 1)
        homeVC.title = "Home"
        favoriteVC.title = "Favorites"
        setViewControllers([homeNav, favoriteNav], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    
    private func setupTabBar() {
        tabBar.tintColor = UIColor.systemBlue
        tabBar.backgroundColor = UIColor.white
        tabBar.isTranslucent = false
    }

}
