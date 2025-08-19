//
//  SceneDelegate.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = MainTabBarController()
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
