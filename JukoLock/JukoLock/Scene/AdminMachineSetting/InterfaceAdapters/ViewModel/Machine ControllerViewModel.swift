//
//  AdminMachineSettingViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 6/7/24.
//

import Combine
import Foundation

final class MachineControllerViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let machineSettingUseCase: AdminMachineSettingUseCases
    let machine: Machine
    let isAdmin: Bool
    
    let adminControllerMenuList: [String] = ["열기", "기기 비밀번호 설정", "유저 비밀번호 설정", "로그확인", "삭제하기"]
    let userControllerMenuList: [String] = ["열기", "비밀번호 설정"]
    
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
        case setUserPassword(_ password: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case machineRenameSuccess(_ newName: String)
        case machineReanmeFailure
        case isOpenSignalSentSuccess
        case isOpenSignalSentFailure
        case userPasswordSetSuccess
        case userPasswordSetFailure
    }
}

// MARK: - Methods

extension MachineControllerViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .openMachine:
                    self?.openMachine(uuid: self?.machine.uuid ?? "")
                case let .machineRename(newName):
                    // TODO: - 옵셔널 값 처리 제대로
                    self?.machineRename(uuid: self?.machine.uuid ?? "", newName: newName)
                case let .setUserPassword(password):
                    self?.setUserPassword(uuid: self?.machine.uuid ?? "", password: password)
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
    
    func setUserPassword(uuid: String, password: String) {
        self.machineSettingUseCase.setUserPassword(uuid: uuid, newPassword: password)
            .receive(on: DispatchQueue.global())
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Machine User Password Setting Fail: \(error)")
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    self?.outputSubject.send(.userPasswordSetSuccess)
                default:
                    self?.outputSubject.send(.userPasswordSetFailure)
                }
            }
            .store(in: &subscriptions)
    }
}
