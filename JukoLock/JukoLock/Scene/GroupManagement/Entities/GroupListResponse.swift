//
//  GroupListResponse.swift
//  JukoLock
//
//  Created by 김경호 on 8/12/24.
//

import Foundation

struct GroupListResponse: Codable {
    let status: String
    let data: [Group]
    let message: String?
}
