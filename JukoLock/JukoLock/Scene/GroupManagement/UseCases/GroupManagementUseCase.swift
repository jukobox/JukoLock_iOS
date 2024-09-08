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
    func execute(guid: String) -> AnyPublisher<GroupUserListResponse, HTTPError> // 그룹 유저 목록 받아오기
    func execute(receiveUserEmail: String, groupId: String) -> AnyPublisher<UserInviteResponse, HTTPError> // 그룹 유저 초대
}

struct GroupManagementUseCase: GroupManagementUseCaseProtocol {
    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute() -> AnyPublisher<GroupListResponse, HTTPError> {
        return provider.request(GroupManagementEndPoint.getGroupList)
    }
    
    func execute(guid: String) -> AnyPublisher<GroupUserListResponse, HTTPError> {
        return provider.request(GroupManagementEndPoint.getGroupUserList(guid: guid))
    }
    
    func execute(receiveUserEmail: String, groupId: String) -> AnyPublisher<UserInviteResponse, HTTPError> {
        return provider.request(CreateEndPoint.inviteUser(userEmail: receiveUserEmail, groupId: groupId))
    }
}
