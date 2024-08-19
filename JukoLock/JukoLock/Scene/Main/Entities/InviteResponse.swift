//
//  InviteResponse.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Foundation

struct InviteResponse: Codable {
    let status: String
    let data: [Invite]
    let message: String?
}
