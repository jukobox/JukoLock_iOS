//
//  CreateGroupUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 8/5/24.
//

import Combine
import Foundation

protocol CreateGroupUseCaseProtocol {
    func execute(groupName: String) -> AnyPublisher<CreateGroupResponse, HTTPError> // 그룹 생성
}

struct CreateGroupUseCase: CreateGroupUseCaseProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute(groupName: String) -> AnyPublisher<CreateGroupResponse, HTTPError> {
        return provider.request(CreateEndPoint.createGroup(groupName: groupName))
    }
}
