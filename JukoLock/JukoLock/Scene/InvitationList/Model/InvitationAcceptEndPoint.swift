//
//  InvitationAcceptEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Foundation

enum InvitationAcceptEndPoint {
    case invitationAccept(groupId: Int)
}

extension InvitationAcceptEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .invitationAccept:
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
        case let .invitationAccept(groupId):
            return .body([
                "groupId": "\(groupId)",
            ])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .invitationAccept:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .invitationAccept:
            return "/group/accept"
        }
    }
}
