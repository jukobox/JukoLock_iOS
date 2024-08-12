//
//  GroupManagementViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 8/4/24.
//

import Combine
import Foundation

final class GroupManagementViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var groupManagementUseCase: GroupManagementUseCaseProtocol
    
    // MARK: - Init
    
    init(groupManagementUseCase: GroupManagementUseCaseProtocol) {
        self.groupManagementUseCase = groupManagementUseCase
    }
    
    // MARK: - Input
    
    
    enum Input {

    }
    
    // MARK: - Output
    
    enum Output {

    }
    
}

// MARK: - Methods

extension GroupManagementViewModel {
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
