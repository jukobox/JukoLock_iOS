//
//  InvitationListEndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Foundation

struct InvitationAcceptResponse: Codable {
    let status: ResponseStatus
    let data: String
    let message: String
}

