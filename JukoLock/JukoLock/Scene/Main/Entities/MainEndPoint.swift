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
    case getMachineList(guid: String)
    case isAdmin(uuid: String)
}

extension MainEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getInvites, .getGroupList, .getMachineList, .isAdmin:
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
        case .getInvites, .getGroupList:
            return .plain
        case let .getMachineList(guid):
            return .query(["guid":guid])
        case let .isAdmin(uuid):
            return .query(["uuid": uuid])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getInvites, .getGroupList, .getMachineList, .isAdmin:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getInvites:
            return "/group/invite"
        case .getGroupList:
            return "/group/list"
        case .getMachineList:
            return "/device/list"
        case .isAdmin:
            return "/device/isAdmin"
        }
    }
}
