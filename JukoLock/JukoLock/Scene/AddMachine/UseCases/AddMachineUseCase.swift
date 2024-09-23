//
//  AddMachineUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Combine
import Foundation

protocol AddMachineUseCaseProtocol {
    func execute(machineId: String, machineName: String, guid: String) -> AnyPublisher<AddMachineResponse, HTTPError> // 기기 추가
}

struct AddMachineUseCase: AddMachineUseCaseProtocol {
    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }
    
    func execute(machineId: String, machineName: String, guid: String) -> AnyPublisher<AddMachineResponse, HTTPError> {
        return provider.request(AddMachineEndPoint.addMachine(machineId: machineId, machineName: machineName, guid: guid))
    }
}
