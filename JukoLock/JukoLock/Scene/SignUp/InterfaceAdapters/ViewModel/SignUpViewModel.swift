//
//  SignUpViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 5/28/24.
//

import Combine
import Foundation

final class SignUpViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var signUpUseCase: SignUpUseCase
    private var name: String = ""
    private var email: String = ""
    private var pw: String = ""
    private var pwCheck: String = ""
    private var emailDuplicationCheck: Bool = false
    
    // MARK: - Init
    
    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case nameInput(_ name: String)
        case emailInput(_ email: String)
        case passwordInput(_ pw: String)
        case passwordCheckInput(_ pwCheck: String)
        case emailDuplicationCheck
        case signUp
    }
    
    // MARK: - Output
    
    enum Output {
        case nameValid(_ text: String)
        case emailValid(_ text: String)
        case pwValid(_ text: String)
        case pwCheckValid(_ text: String)
        case isSignUpPossible
        case isSignUpImpossible
        case emailNotDuplication
        case emailDuplication
        case signUpCompleted
        case signUpFailed
        case signUpError
    }
}

// MARK: - Methods

extension SignUpViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .nameInput(name):
                    self?.inputName(name)
                case let .emailInput(email):
                    self?.inputEmail(email)
                case let .passwordInput(pw):
                    self?.inputPassword(pw)
                case let .passwordCheckInput(pwCheck):
                    self?.inputPasswordCheck(pwCheck)
                case .signUp:
                    self?.signUp()
                case .emailDuplicationCheck:
                    self?.checkVerificationEmail()
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func signUp() {
        signUpUseCase.execute(signUpEmail: email, password: pw)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("SignUp Error : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status{
                case .success:
                    self?.initGroupCreate(name: self?.name ?? "내 그룹")
                case .failure:
                    self?.outputSubject.send(.signUpFailed)
                default:
                    self?.outputSubject.send(.signUpError)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func inputName(_ name: String) {
        self.emailDuplicationCheck = false
        self.name = name
    }
    
    private func inputEmail(_ email: String) {
        self.email = email
        self.emailDuplicationCheck = false
        
        if !isValidEmail(self.email) && !self.email.isEmpty {
            outputSubject.send(.emailValid("Email이 유효하지 않습니다."))
        } else {
            outputSubject.send(.emailValid(""))
        }
        isSignUpPossible()
    }
    
    private func inputPassword(_ pw: String) {
        self.pw = pw
        
        if !isValidPW(pw) && !self.email.isEmpty {
            outputSubject.send(.pwValid("PassWord가 유효하지 않습니다."))
        } else {
            outputSubject.send(.pwValid(""))
        }
        isSignUpPossible()
    }
    
    private func inputPasswordCheck(_ pwCheck: String) {
        self.pwCheck = pwCheck
        
        if !isValidPWCheck(pwCheck) && !self.pwCheck.isEmpty {
            outputSubject.send(.pwCheckValid("PassWord가 일치하지 않습니다."))
        } else {
            outputSubject.send(.pwCheckValid(""))
        }
        isSignUpPossible()
    }
    
    private func isSignUpPossible() {
        if !name.isEmpty && !email.isEmpty && !pw.isEmpty && !pwCheck.isEmpty && isValidEmail(email) && isValidPW(pw) && isValidPWCheck(pwCheck) && emailDuplicationCheck {
            outputSubject.send(.isSignUpPossible)
        } else {
            outputSubject.send(.isSignUpImpossible)
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
    
    private func isValidPWCheck(_ pwCheck: String) -> Bool {
        return self.pw == pwCheck
    }
    
    private func emailValidationCheck(email: String) {
        signUpUseCase.execute(validationEmail: email)
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
        signUpUseCase.execute(sendEmail: email)
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
    
    private func checkVerificationEmail() {
        signUpUseCase.execute(checkVerification: email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Send Email Error : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status{
                case .success:
                    self?.emailDuplicationCheck = true
                    self?.outputSubject.send(.emailNotDuplication)
                    self?.isSignUpPossible()
                default:
                    self?.outputSubject.send(.emailDuplication)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func initGroupCreate(name: String) {
        signUpUseCase.execute(groupName: name)
            .receive(on: DispatchQueue.global())
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Group Create Fail")
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    self?.outputSubject.send(.signUpCompleted)
                case .failure:
                    self?.outputSubject.send(.signUpFailed)
                default:
                    self?.outputSubject.send(.signUpError)
                }
            }
    }
}
