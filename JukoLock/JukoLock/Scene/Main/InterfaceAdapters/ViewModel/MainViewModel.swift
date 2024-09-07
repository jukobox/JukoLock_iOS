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
    
    // TODO: - API 연결되면 Static 데이터 삭제
    private(set) var groupNames: [String] = ["김경호", "박준형", "배성두"]
    private(set) var machines: [Machine] = [
        Machine(machineName: "도어락 1", machineLastDay: "2024.07.02 15:37"),
        Machine(machineName: "도어락 2", machineLastDay: "2024.07.04 08:48"),
        Machine(machineName: "도어락 3", machineLastDay: "2023.01.02 23:43"),
        Machine(machineName: "도어락 4", machineLastDay: "2024.07.09 17:02"),
        Machine(machineName: "도어락 5", machineLastDay: "2024.08.25 18:16"),
        Machine(machineName: "도어락 6", machineLastDay: "2024.09.07 16:56"),
        Machine(machineName: "도어락 7", machineLastDay: "2024.02.09 07:32")
        ]
    
    // MARK: - Init
    
    init(mainUseCase: MainUseCase) {
        self.mainUseCase = mainUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case checkInvite
        case mainPageInit
    }
    
    // MARK: - Output
    
    enum Output {
        case isInvitationReceived
        case isInvitationNotReceived
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
                    self?.loadDatas()
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
                if response.status == "success" {
                    if response.data.isEmpty {
                        self?.outputSubject.send(.isInvitationNotReceived)
                    } else {
                        self?.outputSubject.send(.isInvitationReceived)
                        self?.noties = response.data
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func loadDatas() {
        mainUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(errror) = completion {
                    debugPrint("Main Data Load Fail")
                }
            } receiveValue: { [weak self] response in
                if response.status == "success" {
                    if !response.data.isEmpty {
                        // TODO: API 연결
                    }
                }
            }
    }
}
