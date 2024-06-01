//
//  LoginEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 5/27/24.
//

import Foundation

enum LoginEndPoint {
    case emailValidationCheck(email: String) // 이메일 중복 체크
    case sendVerificationEmail(email: String) // 인증번호 발송
    case checkVerificationEmail(email: String) // 인증번호 인증
    case signUp(email: String, password: String) // 회원가입
    case login(email: String, password: String) // 로그인
}

extension LoginEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .emailValidationCheck(_):
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .sendVerificationEmail(_):
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .checkVerificationEmail(_):
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .signUp(_, _):
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .login(_, _):
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        }
    }
    
    var parameter: HTTPParameter {
        switch self {
        case let .emailValidationCheck(email):
            return .query(["email":email])
        case let .sendVerificationEmail(email):
            return .body(["email" : email])
        case let .checkVerificationEmail(email):
            return .body(["email" : email])
        case let .signUp(email, password):
            return .body(["email" : email,
                          "password" : password
                         ])
        case let .login(email, password):
            return .body(["email" : email,
                          "password" : password
                         ])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkVerificationEmail, .emailValidationCheck:
            return .get
        case .sendVerificationEmail, .login, .signUp:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .emailValidationCheck(_):
            return "/register/email-validation"
        case .sendVerificationEmail(_):
            return "/register/verification"
        case .checkVerificationEmail(_):
            return "/register/verification"
        case .signUp(_, _):
            return "/register/register"
        case .login(_, _):
            return "/login"
        }
    }
}
