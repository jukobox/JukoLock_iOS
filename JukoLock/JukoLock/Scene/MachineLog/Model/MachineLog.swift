//
//  MachineLog.swift
//  JukoLock
//
//  Created by 김경호 on 9/7/24.
//

import Foundation

struct MachineLog: Codable {
    let device: Machine
    let logType: String
    let contents: String
    let rdate: String
}
