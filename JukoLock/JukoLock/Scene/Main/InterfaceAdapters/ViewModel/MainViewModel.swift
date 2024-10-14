//
//  MainViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 6/1/24.
//

import Combine
import Foundation

final class MainViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var mainUseCase: MainUseCase
    private var email: String = ""
    private var pw: String = ""
    var noties: [Invite] = []
    
    private(set) var groupList: [Group] = []
    private(set) var machines: [Machine] = []
    private(set) var selectedGroupIndex: Int = 0
    
    // MARK: - Init
    
    init(mainUseCase: MainUseCase) {
        self.mainUseCase = mainUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case checkInvite
        case mainPageInit
        case selectGroup(index: Int)
        case getMachineList
    }
    
    // MARK: - Output
    
    enum Output {
        case isInvitationReceived
        case isInvitationNotReceived
        case getGroupListSuccess
        case getMachineListSuccess
        case setGroup(groupName: String)
    }
    
}

// MARK: - Methods

extension MainViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .checkInvite:
                    self?.getInvitation()
                case .mainPageInit:
                    self?.getGroupList()
                case let .selectGroup(index):
                    self?.selectedGroupIndex = index
                    let group = self?.groupList[index]
                    self?.outputSubject.send(.setGroup(groupName: group?.name ?? ""))
                    self?.getMachineList()
                case .getMachineList:
                    self?.getMachineList()
                }
            }
            .store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func getInvitation() {
        mainUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Invitation Get Fail! : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    if response.data.isEmpty {
                        self?.outputSubject.send(.isInvitationNotReceived)
                    } else {
                        self?.outputSubject.send(.isInvitationReceived)
                        self?.noties = response.data
                    }
                default :
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    private func getGroupList() {
        mainUseCase.getGroupList()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Group List Get Fail")
                }
            } receiveValue: { [weak self] response in
                if response.status == .success && !response.data.isEmpty {
                    self?.groupList = response.data
                    self?.outputSubject.send(.getGroupListSuccess)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func getMachineList() {
        mainUseCase.getMachineList(guid: groupList[selectedGroupIndex].guid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Group List Get Fail")
                }
            } receiveValue: { [weak self] response in
                if response.status == .success {
                    self?.machines = response.data
                    self?.outputSubject.send(.getMachineListSuccess)
                }
            }
            .store(in: &subscriptions)
    }
}

