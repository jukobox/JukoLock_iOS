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
    case signUp(email: String, password: String, nickname: String) // 회원가입
    case login(email: String, password: String) // 로그인
    case groupCreate(groupName: String) // 기본 그룹 생성
}

extension LoginEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .emailValidationCheck:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .sendVerificationEmail:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .checkVerificationEmail:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .signUp:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .login:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App"
            ]
        case .groupCreate:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App",
                "Authorization": "Bearer \(KeyChainManager.load(key: KeyChainManager.Keywords.accessToken)!)"
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
        case let .signUp(email, password, nickname):
            return .body(["email" : email,
                          "password" : password,
                          "nickname" : nickname
                         ])
        case let .login(email, password):
            return .body(["email" : email,
                          "password" : password
                         ])
        case let .groupCreate(groupName):
            return .body(["groupName" : groupName
            ])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkVerificationEmail, .emailValidationCheck:
            return .get
        case .sendVerificationEmail, .login, .signUp, .groupCreate:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .emailValidationCheck:
            return "/register/email-validation"
        case .sendVerificationEmail:
            return "/register/verification"
        case .checkVerificationEmail:
            return "/register/verification"
        case .signUp:
            return "/register/register"
        case .login:
            return "/login"
        case .groupCreate:
            return "/group/create"
        }
    }
}
