//
//  MachineLogGetResponse.swift
//  JukoLock
//
//  Created by 김경호 on 10/10/24.
//

import Foundation

struct MachineLogGetResponse: Codable {
    let status: ResponseStatus
    let data: [MachineLog]
    let message: String?
}
