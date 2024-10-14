//
//  CreateGroupResponse.swift
//  JukoLock
//
//  Created by 김경호 on 8/12/24.
//

import Foundation

struct CreateGroupResponse: Codable {
    let status: ResponseStatus
    let data: Group?
    let message: String?
}
