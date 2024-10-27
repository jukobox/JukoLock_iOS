//
//  Untitled.swift
//  JukoLock
//
//  Created by 김경호 on 10/26/24.
//

import Foundation

struct SetUserPasswordResponse: Codable {
    let status: ResponseStatus
    let data: String?
    let message: String?
}
