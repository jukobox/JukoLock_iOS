//
//  ResponseStatus.swift
//  JukoLock
//
//  Created by 김경호 on 10/10/24.
//

enum ResponseStatus: String, Codable {
    case success = "success"
    case failure = "fail"
    case error = "error"
    
    init?(rawValue: String) {
        switch rawValue {
        case "success": self = .success
        case "fail": self = .failure
        case "error": self = .error
        default: return nil
        }
    }
}
