//
//  MachineLogUseCases.swift
//  JukoLock
//
//  Created by 김경호 on 10/10/24.
//

import Combine
import Foundation

protocol MachineLogUseCasesProtocol {
    func execute(uuid: String) -> AnyPublisher<MachineLogGetResponse, HTTPError> // Log Get
}

struct MachineLogUseCases: MachineLogUseCasesProtocol {
    private let provider: Requestable
    
    init(provider: APIProvider) {
        self.provider = provider
    }

    func execute(uuid: String) -> AnyPublisher<MachineLogGetResponse, HTTPError> {
        return provider.request(MachineLogGetEndPoint.getMachineLogList(uuid: uuid))
    }
}
