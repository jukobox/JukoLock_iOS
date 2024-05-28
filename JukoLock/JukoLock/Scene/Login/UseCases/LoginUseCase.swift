//
//  LoginUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 5/27/24.
//

import Combine
import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) -> AnyPublisher<LoginResponse, HTTPError> // 로그인
    func execute(signUpEmail: String, password: String) -> AnyPublisher<Never, HTTPError> // 회원가입
    func execute(validationEmail: String) -> AnyPublisher<Never, HTTPError> // 인증번호 발송
    func execute(sendEmail: String) -> AnyPublisher<Never, HTTPError> // 인증번호 인증
    func execute(checkVerification: String) -> AnyPublisher<Never, HTTPError> // 이메일 중복 체크
}

struct LoginUseCase: LoginUseCaseProtocol {
    
    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }
    
    func execute(email: String, password: String) -> AnyPublisher<LoginResponse, HTTPError> {
        return provider.request(LoginEndPoint.login(email: email, password: password))
    }
    
    func execute(signUpEmail: String, password: String) -> AnyPublisher<Never, HTTPError> {
        return provider.request(LoginEndPoint.signUp(email: signUpEmail, password: password))
    }
    
    func execute(validationEmail: String) -> AnyPublisher<Never, HTTPError> {
        return provider.request(LoginEndPoint.checkVerificationEmail(email: validationEmail))
    }
    
    func execute(sendEmail: String) -> AnyPublisher<Never, HTTPError> {
        return provider.request(LoginEndPoint.sendVerificationEmail(email: sendEmail))
    }
    
    func execute(checkVerification: String) -> AnyPublisher<Never, HTTPError> {
        return provider.request(LoginEndPoint.checkVerificationEmail(email: checkVerification))
    }
}
