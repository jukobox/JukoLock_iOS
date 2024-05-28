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
    
    // MARK: - Init
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    // MARK: - Input
    
    
    enum Input {
        case Login(email: String, password: String)
        case SignUp(email: String, password: String)
    }
    
    // MARK: - Output
    
    enum Output {
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
                case let .Login(email, password):
                    self?.login(email: email, password: password)
                case let .SignUp(email, password):
                    self?.signUp(email: email, password: password)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func login(email: String, password: String) {
        loginUseCase.execute(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Login Error : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status{
                case "success":
                    self?.outputSubject.send(.loginCompleted)
                case "Fail":
                    self?.outputSubject.send(.loginFailed)
                default:
                    self?.outputSubject.send(.loginError)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func signUp(email: String, password: String) {
        loginUseCase.execute(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("SignUp Error : ", error)
                }
            } receiveValue: { [weak self] response in
                // TODO: - 회원가입 API 연결
                switch response.status{
                case "success":
                    debugPrint("회원가입 성공")
                case "Fail":
                    debugPrint("회원가입 실패")
                default:
                    debugPrint("회원가입 에러")
                }
                debugPrint(response)
            }
            .store(in: &subscriptions)
    }
    
    private func emailValidationCheck(email: String) {
        loginUseCase.execute(validationEmail: email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Email Validation Error : ", error)
                }
            } receiveValue: { [weak self] response in
                debugPrint(response)
            }
            .store(in: &subscriptions)
    }
    
    private func sendVerificationEmail(email: String) {
        loginUseCase.execute(sendEmail: email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Send Email Error : ", error)
                }
            } receiveValue: { [weak self] response in
                debugPrint(response)
            }
            .store(in: &subscriptions)
    }
    
    private func checkVerificationEmail(email: String) {
        loginUseCase.execute(checkVerification: email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Send Email Error : ", error)
                }
            } receiveValue: { [weak self] response in
                debugPrint(response)
            }
            .store(in: &subscriptions)
    }
}
