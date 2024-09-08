//
//  GroupManagementEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 8/12/24.
//

import Foundation

enum GroupManagementEndPoint {
    case getGroupList
    case getGroupUserList(guid: String)
}

extension GroupManagementEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getGroupList, .getGroupUserList:
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
        case .getGroupList:
            return .plain
        case let .getGroupUserList(guid):
            return .query(["guid":guid])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getGroupList, .getGroupUserList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getGroupList:
            return "/group/list"
        case .getGroupUserList:
            return "/group/userList"
        }
    }
}
