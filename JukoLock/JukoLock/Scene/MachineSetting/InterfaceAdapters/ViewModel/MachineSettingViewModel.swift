//
//  MachineSettingViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 6/7/24.
//

import Combine
import Foundation

final class MachineSettingViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let machineSettingUseCase: MachineSettingUseCases
    let machine: Machine
    
    // MARK: - Init
    
    init(machine: Machine, machineSettingUseCase: MachineSettingUseCases) {
        self.machine = machine
        self.machineSettingUseCase = machineSettingUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case machineRename(_ newName: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case machineRenameSuccess(_ newName: String)
        case machineReanmeFailure
    }
    
}

// MARK: - Methods

extension MachineSettingViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .machineRename(newName):
                    // TODO: - 옵셔널 값 처리 제대로
                    self?.machineRename(uuid: self?.machine.uuid ?? "", newName: newName)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func machineRename(uuid: String, newName: String) {
        machineSettingUseCase.execute(uuid: uuid, newName: newName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Machine Rename Failure : \(error)")
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case "success":
                    self?.outputSubject.send(.machineRenameSuccess(newName))
                default:
                    self?.outputSubject.send(.machineReanmeFailure)
                }
            }
            .store(in: &subscriptions)
    }
}
