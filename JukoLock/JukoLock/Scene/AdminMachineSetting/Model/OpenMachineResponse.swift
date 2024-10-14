//
//  OpenMachineResponse.swift
//  JukoLock
//
//  Created by 김경호 on 10/14/24.
//

import Foundation

struct OpenMachineResponse: Codable {
    let status: ResponseStatus
    let data: String?
    let message: String?
}
