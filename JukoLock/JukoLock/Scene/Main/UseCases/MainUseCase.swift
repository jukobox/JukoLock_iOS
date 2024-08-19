//
//  MainUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Combine
import Foundation

protocol MainUseCaseProtocol {
    func execute() -> AnyPublisher<InviteResponse, HTTPError> // 초대 목록 받아오기
}

struct MainUseCase: MainUseCaseProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute() -> AnyPublisher<InviteResponse, HTTPError> {
        return provider.request(MainEndPoint.getInvites)
    }
}
