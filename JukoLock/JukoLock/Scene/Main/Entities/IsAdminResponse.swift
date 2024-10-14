//
//  IsAdminResponse.swift
//  JukoLock
//
//  Created by 김경호 on 10/14/24.
//

import Foundation

struct IsAdminResponse: Codable {
    let status: ResponseStatus
    let data: Bool
    let message: String?
}
