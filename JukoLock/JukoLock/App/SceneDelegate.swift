//
//  SceneDelegate.swift
//  JukoLock
//
//  Created by 김경호 on 4/9/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let viewController = TabBarController()

        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

