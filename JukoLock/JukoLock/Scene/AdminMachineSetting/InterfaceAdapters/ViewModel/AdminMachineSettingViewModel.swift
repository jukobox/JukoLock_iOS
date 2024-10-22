//
//  AdminMachineSettingViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 6/7/24.
//

import Combine
import Foundation

final class AdminMachineSettingViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let machineSettingUseCase: AdminMachineSettingUseCases
    let machine: Machine
    let isAdmin: Bool
    
    // MARK: - Init
    
    init(machine: Machine, isAdmin: Bool, machineSettingUseCase: AdminMachineSettingUseCases) {
        self.machine = machine
        self.isAdmin = isAdmin
        self.machineSettingUseCase = machineSettingUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case openMachine
        case machineRename(_ newName: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case machineRenameSuccess(_ newName: String)
        case machineReanmeFailure
        case isOpenSignalSentSuccess
        case isOpenSignalSentFailure
    }
}

// MARK: - Methods

extension AdminMachineSettingViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .openMachine:
                    self?.openMachine(uuid: self?.machine.uuid ?? "")
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
                case .success:
                    self?.outputSubject.send(.machineRenameSuccess(newName))
                default:
                    self?.outputSubject.send(.machineReanmeFailure)
                }
            }
            .store(in: &subscriptions)
    }
    
    func openMachine(uuid: String) {
        self.machineSettingUseCase.execute(uuid: uuid)
            .receive(on: DispatchQueue.global())
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Machine Open Fail: \(error)")
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    self?.outputSubject.send(.isOpenSignalSentSuccess)
                default:
                    self?.outputSubject.send(.isOpenSignalSentFailure)
                }
            }
            .store(in: &subscriptions)
    }
}
