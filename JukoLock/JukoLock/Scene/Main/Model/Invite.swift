//
//  Invite.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Foundation

struct Invite: Codable {
    let id: Int
    let sendUser: User
    let receiveUser: User
    let group: Group
    let rdate: String
}
