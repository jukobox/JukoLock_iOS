//
//  MachineSettingUseCases.swift
//  JukoLock
//
//  Created by 김경호 on 10/3/24.
//

import Combine
import Foundation

protocol MachineSettingUseCasesProtocol {
    func execute(uuid: String, newName: String) -> AnyPublisher<RenameResponse, HTTPError> // 이름 변경
}

struct MachineSettingUseCases: MachineSettingUseCasesProtocol {

    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute(uuid: String, newName: String) -> AnyPublisher<RenameResponse, HTTPError> {
        return provider.request(MachineSettingEndPoint.machineRename(uuid, newName, newName))
    }
}
