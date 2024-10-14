//
//  AdminMachineSettingUseCases.swift
//  JukoLock
//
//  Created by 김경호 on 10/3/24.
//

import Combine
import Foundation

protocol AdminMachineSettingUseCasesProtocol {
    func execute(uuid: String) -> AnyPublisher<OpenMachineResponse, HTTPError> // 기기 Open
    func execute(uuid: String, newName: String) -> AnyPublisher<RenameResponse, HTTPError> // 이름 변경
}

struct AdminMachineSettingUseCases: AdminMachineSettingUseCasesProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }
    
    func execute(uuid: String) -> AnyPublisher<OpenMachineResponse, HTTPError> {
        return provider.request(AdminMachineSettingEndPoint.openMachin(uuid))
    }

    func execute(uuid: String, newName: String) -> AnyPublisher<RenameResponse, HTTPError> {
        return provider.request(AdminMachineSettingEndPoint.machineRename(uuid, newName, newName))
    }
}

