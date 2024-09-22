//
//  AddMachineResponse.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Foundation

struct AddMachineResponse: Codable {
    let status: String
    let data: String?
    let message: String?
}
