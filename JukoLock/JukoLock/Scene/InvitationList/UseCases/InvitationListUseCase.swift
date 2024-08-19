//
//  InvitationUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Combine
import Foundation

protocol InvitationListUseCaseProtocol {
    func execute(groupId: Int) -> AnyPublisher<InvitationAcceptResponse, HTTPError> // 그룹 생성
}

struct InvitationListUseCase: InvitationListUseCaseProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute(groupId: Int) -> AnyPublisher<InvitationAcceptResponse, HTTPError> {
        return provider.request(InvitationAcceptEndPoint.invitationAccept(groupId: groupId))
    }
}
