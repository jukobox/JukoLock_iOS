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
        
        let navMainVC = UINavigationController(rootViewController: MainViewController(viewModel: MainViewModel(mainUseCase: MainUseCase(provider: APIProvider(session: URLSession.shared)))))
        let navMyProfile = UINavigationController(rootViewController: MyProfileViewController())
        
        navMainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), tag: 0)
        navMyProfile.tabBarItem = UITabBarItem(title: "MyProfile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 1)
        
        viewControllers = [navMainVC, navMyProfile]
    }
}
