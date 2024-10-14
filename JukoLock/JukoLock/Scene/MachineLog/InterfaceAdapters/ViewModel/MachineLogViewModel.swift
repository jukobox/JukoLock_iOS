//
//  MachineLogViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 9/7/24.
//

import Combine
import Foundation

final class MachineLogViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let machineLogUseCases: MachineLogUseCases
    private let uuid: String
    var logs:[MachineLog] = []
    
    // MARK: - Init
    
    init(machineLogUsecases: MachineLogUseCases, uuid: String) {
        self.machineLogUseCases = machineLogUsecases
        self.uuid = uuid
    }
    
    // MARK: - Input
    
    enum Input {
        case MachineLogGet
    }
    
    // MARK: - Output
    
    enum Output {
        case MachineLogGetSuccess
        case MachineLogGetFail
    }
    
}

// MARK: - Methods

extension MachineLogViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .MachineLogGet:
                    self?.getMachineLog(uuid: self?.uuid ?? "")
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func getMachineLog(uuid: String) {
        machineLogUseCases.execute(uuid: uuid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Get Log Fail : ", error)
                    self.outputSubject.send(.MachineLogGetFail)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    self?.logs = response.data
                    self?.outputSubject.send(.MachineLogGetSuccess)
                default:
                    self?.outputSubject.send(.MachineLogGetFail)
                }
            }
            .store(in: &subscriptions)
    }
}
