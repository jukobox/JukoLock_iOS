//
//  TabBarController.swift
//  JukoLock
//
//  Created by 김경호 on 5/20/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MainViewController()
        let navMainVC = UINavigationController(rootViewController: mainVC)
        navMainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), tag: 0)
        
        viewControllers = [navMainVC]
    }
}
