//
//  GroupManagementUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 8/5/24.
//

import Combine
import Foundation

protocol GroupManagementUseCaseProtocol {
    func execute() -> AnyPublisher<GroupListResponse, HTTPError>
}

struct GroupManagementUseCase: GroupManagementUseCaseProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute() -> AnyPublisher<GroupListResponse, HTTPError> {
        return provider.request(GroupManagementEndPoint.getGroupList)
    }
}
