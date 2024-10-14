//
//  RenameResponse.swift
//  JukoLock
//
//  Created by 김경호 on 10/3/24.
//

import Foundation

struct RenameResponse: Codable {
    let status: ResponseStatus
    let data: String?
    let message: String?
}
