//
//  MachineListResponse.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Foundation

struct MachineListResponse: Codable {
    let status: String
    let data: [Machine]
    let message: String?
}
