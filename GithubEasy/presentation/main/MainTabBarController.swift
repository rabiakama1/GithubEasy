//
//  MainTabBarController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabsAppearance()
    }
    
    private func setupTabsAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.tintColor = .systemBlue
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
