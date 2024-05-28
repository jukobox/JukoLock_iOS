//
//  SceneDelegate.swift
//  JukoLock
//
//  Created by 김경호 on 4/9/24.
//

import Combine
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    private var cancellables = Set<AnyCancellable>()
    private var loginStateSubject = CurrentValueSubject<LoginState, Never>(.loogedOut)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        bind()
    }
}

// MARK: - Methods
extension SceneDelegate {
    func switchViewController(for loginState: LoginState) {
        switch loginState {
        case .loggedIn:
            let tabBarViewController = TabBarController()
            self.navigationController = UINavigationController(rootViewController: tabBarViewController)
            self.window?.rootViewController = self.navigationController
        case .loogedOut:
            let provider = APIProvider(session: URLSession.shared)
            let useCase = LoginUseCase(provider: provider)
            let viewModel = LoginViewModel(loginUseCase: useCase)
            let loginViewController = LoginViewController(viewModel: viewModel, loginStateSubject: loginStateSubject)
            self.navigationController = UINavigationController(rootViewController: loginViewController)
            self.window?.rootViewController = self.navigationController
        }
        
        self.window?.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    
    func bind() {
        loginStateSubject
            .sink { [weak self] isLoginState in
                self?.switchViewController(for: isLoginState)
            }
            .store(in: &cancellables)
    }
}
