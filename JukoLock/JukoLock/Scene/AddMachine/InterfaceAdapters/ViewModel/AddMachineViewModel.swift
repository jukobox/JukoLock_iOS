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
    
    private(set) var selectedGroupIndex: Int = 0
    private(set) var machineName: String = ""
    private(set) var groupList: [Group] = []
    private(set) var machineId: String = ""
    
    // MARK: - Init
    
    init(addMachineUseCase: AddMachineUseCase, groupList: [Group], userName: String) {
        self.addMachineUseCase = addMachineUseCase
        self.groupList = groupList
        self.machineName = "\(userName)의 도어락"
    }
    
    // MARK: - Input
    
    enum Input {
        case machineSettingViewDisAppear
        case qrReadSuccess(machineId: String)
        case machineNameInput(name: String)
        case groupSelected(selectedRow: Int)
        case addMachineSettingCompleted
    }
    
    // MARK: - Output
    
    enum Output {
        case settingViewDisAppear
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
                    self?.machineId = machineId
                case let .machineNameInput(name):
                    self?.machineName = name
                case let .groupSelected(selectedRow):
                    self?.selectedGroupIndex = selectedRow
                case .addMachineSettingCompleted:
                    self?.addMachine()
                case .machineSettingViewDisAppear:
                    self?.outputSubject.send(.settingViewDisAppear)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func addMachine() {
        addMachineUseCase.execute(machineId: self.machineId, machineName: self.machineName, guid: self.groupList[selectedGroupIndex].guid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Add Machine Erorr : ", error)
                }
            } receiveValue : { [weak self] response in
                switch response.status {
                case .success:
                    self?.outputSubject.send(.addMachineSuccess)
                default:
                    self?.outputSubject.send(.addMachineFail)
                }
            }
            .store(in: &subscriptions)
    }
}
