//
//  MachineSettingEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 10/3/24.
//

import Foundation

enum MachineSettingEndPoint {
    case machineRename(String, String, String)
}

extension MachineSettingEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .machineRename(_,_,_):
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
        case .machineRename(_, _, _):
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .machineRename(_, _, _):
            return "device/rename"
        }
    }
}
