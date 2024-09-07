//
//  GetInvitesEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Foundation

enum MainEndPoint {
    case getInvites
    case getGroupList
}

extension MainEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getInvites:
            return [
                "Content-Type": "application/json",
                "Contents-Length": "1000",
                "Host": "JukoLock.App",
                "Authorization": "Bearer \(KeyChainManager.load(key: KeyChainManager.Keywords.accessToken)!)"
            ]
        case .getGroupList:
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
        case .getInvites:
            return .plain
        case .getGroupList:
            return .plain
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getInvites:
            return .get
        case .getGroupList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getInvites:
            return "/group/invite"
        case .getGroupList:
            return "/group/list"
        }
    }
}
