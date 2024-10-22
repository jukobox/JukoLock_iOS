//
//  InvitationUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Combine
import Foundation

protocol InvitationListUseCaseProtocol {
    func invitationAccept(invitationId: Int) -> AnyPublisher<InvitationAcceptResponse, HTTPError> // 그룹 초대 수락
}

struct InvitationListUseCase: InvitationListUseCaseProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func invitationAccept(invitationId: Int) -> AnyPublisher<InvitationAcceptResponse, HTTPError> {
        return provider.request(InvitationAcceptEndPoint.invitationAccept(invitationId: invitationId))
    }
}
