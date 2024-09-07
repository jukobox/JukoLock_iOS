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
    let logs:[MachineLog] = [
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
            MachineLog(machine: Machine(machineName: "도어락 1", machineLastDay: "2024/09/07 19:19"), user: "김경호", date: "2024/09/07 19:19"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2024/07/19 16:23"), user: "박준형", date: "2024/07/19 16:23"),
            MachineLog(machine: Machine(machineName: "도어락 2", machineLastDay: "2023/11/02 07:20"), user: "배성두", date: "2023/11/02 07:20"),
            MachineLog(machine: Machine(machineName: "도어락 3", machineLastDay: "2024/07/22 17:23"), user: "김경호", date: "2024/07/22 17:23"),
    ]
    
    // MARK: - Init
    
    // MARK: - Input
    
    enum Input {
        
    }
    
    // MARK: - Output
    
    enum Output {
    }
    
}

// MARK: - Methods

extension MachineLogViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {

                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
}
