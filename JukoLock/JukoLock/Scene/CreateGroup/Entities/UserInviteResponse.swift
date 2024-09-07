//
//  UserInviteResponse.swift
//  JukoLock
//
//  Created by 김경호 on 8/20/24.
//

import Foundation

struct UserInviteResponse: Codable {
    let status: String
    let data: String?
    let message: String?
}
