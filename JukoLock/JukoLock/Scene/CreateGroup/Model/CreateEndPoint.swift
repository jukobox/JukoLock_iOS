//
//  CreateEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 8/12/24.
//

import Foundation

enum CreateEndPoint {
    case createGroup(groupName: String)
    case inviteUser(userEmail: String, groupId: String)
}

extension CreateEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .createGroup(_):
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App",
                "Authorization": "Bearer \(KeyChainManager.load(key: KeyChainManager.Keywords.accessToken)!)"
            ]
        case .inviteUser(_, _):
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
        case let .createGroup(groupName):
            return .body(["groupName": groupName])
        case let .inviteUser(userEmail, groupId):
            return .body([
                "receiveUserEmail": userEmail,
                "groupId": groupId
            ])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createGroup, .inviteUser:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createGroup(_):
            return "/group/create"
        case .inviteUser(_, _):
            return "/group/invite"
        }
    }
}
