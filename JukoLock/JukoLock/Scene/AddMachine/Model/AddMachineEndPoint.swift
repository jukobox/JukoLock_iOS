//
//  AddMachineEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Foundation

enum AddMachineEndPoint {
    case addMachine(machineId: String, machineName: String, guid: String)

}

extension AddMachineEndPoint: EndPoint {
    
    var baseURL: String {
        return "http://jaeryum1.duckdns.org:20035/jukolock/api"
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .addMachine:
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
        case let .addMachine(machineId, machineName, guid):
            return .body([
            "uuid": machineId,
            "nickName": machineName,
            "guid": guid
            ])
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .addMachine:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .addMachine:
            return "/device/add"
        }
    }
}
