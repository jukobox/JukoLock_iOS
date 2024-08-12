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
    
    var groupList: [Group] = []
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var groupManagementUseCase: GroupManagementUseCaseProtocol
    
    // MARK: - Init
    
    init(groupManagementUseCase: GroupManagementUseCaseProtocol) {
        self.groupManagementUseCase = groupManagementUseCase
    }
    
    // MARK: - Input
    
    
    enum Input {
        case getGroupList
    }
    
    // MARK: - Output
    
    enum Output {
        case listGetComplete
    }
}

// MARK: - Methods

extension GroupManagementViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .getGroupList:
                    self?.getGroupList()
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func getGroupList() {
        groupManagementUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("List Get Fail : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case "success":
                    self?.groupList = response.data
                    self?.outputSubject.send(.listGetComplete)
                default:
                    debugPrint("List Get Fail")
                }
            }
            .store(in: &subscriptions)
    }
}
