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
    private var groupName: String = ""
    
    // TODO: - 친구 목록 가져오기
    
    // MARK: - Init
    
    init(createGroupUseCase: CreateGroupUseCaseProtocol) {
        self.createGroupUseCase = createGroupUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case groupCreateCompleteButtonTouched
        case groupNameInput(groupName: String)
    }
    
    // MARK: - Output
    
    enum Output {
        case groupCreateComplete
        case groupCreateFail
        case createGroupPossible
        case createGroupImpossible
    }
    
}

// MARK: - Methods

extension CreateViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .groupCreateCompleteButtonTouched:
                    self?.groupCreate()
                case let .groupNameInput(groupName):
                    self?.groupName = groupName
                    if (3...20).contains(groupName.count) {
                        self?.outputSubject.send(.createGroupPossible)
                    } else {
                        self?.outputSubject.send(.createGroupImpossible)
                    }
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func groupCreate(){
        createGroupUseCase.execute(groupName: groupName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("List Get Fail : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case "success":
                    self?.outputSubject.send(.groupCreateComplete)
                default:
                    self?.outputSubject.send(.groupCreateFail)
                }
            }
            .store(in: &subscriptions)
    }
}
