//
//  LoginResponse.swift
//  JukoLock
//
//  Created by 김경호 on 5/28/24.
//

import Foundation

struct LoginResponse: Codable {
    let status: ResponseStatus
    let data: String?
    let message: String?
}
