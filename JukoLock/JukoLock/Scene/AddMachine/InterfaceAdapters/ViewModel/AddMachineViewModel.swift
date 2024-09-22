//
//  AddMachineViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Combine
import Foundation

final class AddMachineViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var addMachineUseCase: AddMachineUseCase
    
    // MARK: - Init
    
    init(addMachineUseCase: AddMachineUseCase) {
        self.addMachineUseCase = addMachineUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case qrReadSuccess(machineId: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case addMachineSuccess
        case addMachineFail
    }
}

// MARK: - Methods

extension AddMachineViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .qrReadSuccess(machineId):
                    self?.addMachine(machineId: machineId)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func addMachine(machineId: String) {
        addMachineUseCase.execute(machineID: machineId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Add Machine Erorr : ", error)
                }
            } receiveValue : { [weak self] response in
                switch response.status {
                case "success":
                    self?.outputSubject.send(.addMachineSuccess)
                default:
                    self?.outputSubject.send(.addMachineFail)
                }
            }
            .store(in: &subscriptions)
    }
}
