//
//  AdminMachineSettingEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 10/3/24.
//

import Foundation

enum AdminMachineSettingEndPoint {
    case openMachin(String)
    case machineRename(String, String, String)
}

extension AdminMachineSettingEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .machineRename, .openMachin:
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
        case let .openMachin(uuid):
            return .body([
                "uuid": uuid
            ])
        case let .machineRename(uuid, name, guid):
            return .body([
                "uuid": uuid,
                "newNickname": name,
                "guid": guid
            ])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .machineRename, .openMachin:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .openMachin:
            return "/device/open"
        case .machineRename:
            return "device/rename"
        }
    }
}
