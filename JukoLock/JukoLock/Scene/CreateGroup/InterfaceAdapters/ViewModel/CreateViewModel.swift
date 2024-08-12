//
//  CreateViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 8/5/24.
//

import Combine
import Foundation

final class CreateViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var createGroupUseCase: CreateGroupUseCaseProtocol
    
    // MARK: - Init
    
    init(createGroupUseCase: CreateGroupUseCaseProtocol) {
        self.createGroupUseCase = createGroupUseCase
    }
    
    // MARK: - Input
    
    
    enum Input {

    }
    
    // MARK: - Output
    
    enum Output {

    }
    
}

// MARK: - Methods

extension CreateViewModel {
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
