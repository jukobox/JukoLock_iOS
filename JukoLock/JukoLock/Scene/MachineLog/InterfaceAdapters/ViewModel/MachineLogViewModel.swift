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
    let logs:[MachineLog] = []
    
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
