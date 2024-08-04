//
//  TokenManager.swift
//  JukoLock
//
//  Created by 김경호 on 8/4/24.
//

import Combine
import Foundation

struct TokenManager {
    static func decodeJWTToken(token: String) -> JWTToken? {
        let tokenComponents = token.components(separatedBy: ".")

        guard tokenComponents.count == 3,
              let payloadData = tokenComponents[1].base64Decoded(),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            return nil
        }
        
        return JWTToken(emial: payload["email"] as? String, iat: payload["iat"] as? TimeInterval, exp: payload["exp"] as? TimeInterval)
    }
    
    static func isTokenExpired() -> LoginState {
        guard let token = KeyChainManager.load(key: KeyChainManager.Keywords.accessToken), let tokenExp = decodeJWTToken(token: token)?.exp else {
            return LoginState.logOut
        }
        let currentTimeInterval = Date().timeIntervalSince1970
        
        return currentTimeInterval < tokenExp ? LoginState.logIn : LoginState.logOut
    }
    
    struct JWTToken {
        let emial: String?
        let iat: TimeInterval?
        let exp: TimeInterval?
    }
}

struct MyClaims: Decodable {
    var sub: String
    var exp: TimeInterval
}

// Base64 디코드를 위한 extension
extension String {
    func base64Decoded() -> Data? {
        let padding = String(repeating: "=", count: (4 - count % 4) % 4)
        guard let data = Data(base64Encoded: replacingOccurrences(of: "-", with: "+")
                                                .replacingOccurrences(of: "_", with: "/") + padding) else {
            return nil
        }
        return data
    }
}
