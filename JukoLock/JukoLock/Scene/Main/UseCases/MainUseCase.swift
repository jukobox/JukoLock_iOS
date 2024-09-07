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
    func getGroupList() -> AnyPublisher<GroupListResponse, HTTPError> // 그룹 목록 받아오기
    func getMachineList(guid: String) -> AnyPublisher<MachineListResponse, HTTPError> // 기기 목록 받아오기
}

struct MainUseCase: MainUseCaseProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute() -> AnyPublisher<InviteResponse, HTTPError> {
        return provider.request(MainEndPoint.getInvites)
    }
    
    func getGroupList() -> AnyPublisher<GroupListResponse, HTTPError> {
        return provider.request(MainEndPoint.getGroupList)
    }
    
    func getMachineList(guid: String) -> AnyPublisher<MachineListResponse, HTTPError> {
        return provider.request(MainEndPoint.getMachineList(guid: guid))
    }
}
