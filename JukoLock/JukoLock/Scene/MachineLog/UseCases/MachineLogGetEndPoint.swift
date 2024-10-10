//
//  MachineLogGetEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 10/10/24.
//

import Foundation

enum MachineLogGetEndPoint {
    case getMachineLogList(uuid: String)
}

extension MachineLogGetEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getMachineLogList:
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
        case let .getMachineLogList(uuid):
            return .query(["uuid": uuid])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMachineLogList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMachineLogList:
            return "/device/log"
        }
    }
}
