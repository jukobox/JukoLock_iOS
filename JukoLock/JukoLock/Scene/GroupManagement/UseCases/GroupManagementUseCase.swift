//
//  GroupManagementUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 8/5/24.
//

import Combine
import Foundation

protocol GroupManagementUseCaseProtocol {

}

struct GroupManagementUseCase: GroupManagementUseCaseProtocol {
    
    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

}
