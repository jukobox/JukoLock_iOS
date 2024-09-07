//
//  SignUpUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 5/28/24.
//

import Combine
import Foundation

protocol SignUpUseCaseProtocol {
    func execute(signUpEmail: String, password: String) -> AnyPublisher<LoginResponse, HTTPError> // 회원가입
    func execute(validationEmail: String) -> AnyPublisher<Never, HTTPError> // 인증번호 발송
    func execute(sendEmail: String) -> AnyPublisher<Never, HTTPError> // 인증번호 인증
    func execute(checkVerification: String) -> AnyPublisher<LoginResponse, HTTPError> // 이메일 중복 체크
    func execute(groupName: String) -> AnyPublisher<LoginResponse, HTTPError> // 기본 그룹 생성
}

struct SignUpUseCase: SignUpUseCaseProtocol {
    
    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }
    
    func execute(signUpEmail: String, password: String) -> AnyPublisher<LoginResponse, HTTPError> {
        return provider.request(LoginEndPoint.signUp(email: signUpEmail, password: password))
    }
    
    func execute(validationEmail: String) -> AnyPublisher<Never, HTTPError> {
        return provider.request(LoginEndPoint.checkVerificationEmail(email: validationEmail))
    }
    
    func execute(sendEmail: String) -> AnyPublisher<Never, HTTPError> {
        return provider.request(LoginEndPoint.sendVerificationEmail(email: sendEmail))
    }
    
    func execute(checkVerification: String) -> AnyPublisher<LoginResponse, HTTPError> {
        return provider.request(LoginEndPoint.emailValidationCheck(email: checkVerification))
    }
    
    func execute(groupName: String) -> AnyPublisher<LoginResponse, HTTPError> {
        return provider.request(LoginEndPoint.groupCreate(groupName: groupName))
    }
}
