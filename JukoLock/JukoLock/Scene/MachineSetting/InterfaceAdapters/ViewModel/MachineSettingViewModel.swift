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
    let machine: Machine
    
    // MARK: - Init
    
    init(machine: Machine) {
        self.machine = machine
    }
    
    // MARK: - Input
    
    enum Input {
        
    }
    
    // MARK: - Output
    
    enum Output {
    }
    
}

// MARK: - Methods

extension MachineSettingViewModel {
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
