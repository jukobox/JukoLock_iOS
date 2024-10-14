//
//  GroupUserListResponse.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Foundation

struct GroupUserListResponse: Codable {
    let status: ResponseStatus
    let data: [User]
    let message: String?
}
