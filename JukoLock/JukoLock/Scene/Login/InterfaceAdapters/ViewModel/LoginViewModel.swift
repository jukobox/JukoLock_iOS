//
//  LoginViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 5/17/24.
//

import Combine
import Foundation

final class LoginViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var loginUseCase: LoginUseCase
    private var email: String = ""
    private var pw: String = ""
    
    // MARK: - Init
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    // MARK: - Input
    
    
    enum Input {
        case emailInput(email: String)
        case passwordInput(pw: String)
        case loginButtonTouched
    }
    
    // MARK: - Output
    
    enum Output {
        case emailValid(text: String)
        case pwValid(text: String)
        case isLoginPossible
        case isLoginImpossible
        case loginCompleted
        case loginFailed
        case loginError
    }
    
}

// MARK: - Methods

extension LoginViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .emailInput(email):
                    self?.inputEmail(email)
                case let .passwordInput(pw):
                    self?.inputPassword(pw)
                case .loginButtonTouched:
                    self?.login()
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func login() {
        loginUseCase.execute(email: email, password: pw)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Login Error : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status{
                case "success":
                    guard let token = response.data else {
                        debugPrint("Token Get Fail!")
                        return // TODO: - throw로 수정
                    }
                    KeyChainManager.save(key: KeyChainManager.Keywords.accessToken, token: token)
                    if KeyChainManager.load(key: "AccessToken") != nil {
                        self?.outputSubject.send(.loginCompleted)
                                    } else {
                                        debugPrint("Token Save Fail")
                                    }
                case "fail":
                    self?.outputSubject.send(.loginFailed)
                default:
                    self?.outputSubject.send(.loginError)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func inputEmail(_ email: String) {
        self.email = email
        
        if !isValidEmail(self.email) && !self.email.isEmpty {
            outputSubject.send(.emailValid(text: "Email이 유효하지 않습니다."))
        } else {
            outputSubject.send(.emailValid(text: ""))
        }
        isLoginPossible()
    }
    
    private func inputPassword(_ pw: String) {
        self.pw = pw
        
        if !isValidPW(pw) && !self.email.isEmpty {
            outputSubject.send(.pwValid(text: "PW가 유효하지 않습니다."))
        } else {
            outputSubject.send(.pwValid(text: ""))
        }
        isLoginPossible()
    }
    
    private func isLoginPossible() {
        if !email.isEmpty && !pw.isEmpty && isValidEmail(email) && isValidPW(pw) {
            outputSubject.send(.isLoginPossible)
        } else {
            outputSubject.send(.isLoginImpossible)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)

        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
    
    private func isValidPW(_ pw: String) -> Bool {
        let pwRegex = "^[A-Za-z0-9!_@$%^&+=]{8,20}$"
        let pwPredicate = NSPredicate(format: "SELF MATCHES[c] %@", pwRegex)

        return !pw.isEmpty && pwPredicate.evaluate(with: pw)
    }
}
