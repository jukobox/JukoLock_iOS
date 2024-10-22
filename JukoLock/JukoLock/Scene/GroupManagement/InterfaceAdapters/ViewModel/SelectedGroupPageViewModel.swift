//
//  SelectedGroupPageViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Combine
import Foundation

final class SelectedGroupPageViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var groupManagementUseCase: GroupManagementUseCaseProtocol
    private let groupId: String
    private var email: String = ""
    var groupUsers: [User] = []
    
    // MARK: - Init
    
    init(groupManagementUseCase: GroupManagementUseCaseProtocol, groupId: String) {
        self.groupManagementUseCase = groupManagementUseCase
        self.groupId = groupId
    }
    
    // MARK: - Input
    
    enum Input {
        case getUserList
        case addEmailInput(email: String)
        case addEmailButtonTouched
    }
    
    // MARK: - Output
    
    enum Output {
        case getUserListSuccess
        case addEmailPossible
        case addEmailImpossible
        case addEmailInputSuccess
        case addEmailInputFail
    }
}

// MARK: - Methods

extension SelectedGroupPageViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case .getUserList:
                    self?.getGroupUsers()
                case let .addEmailInput(email):
                    self?.email = email
                    self?.isAddEmailPossible()
                case .addEmailButtonTouched:
                    self?.groupUserAdd()
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func getGroupUsers() {
        groupManagementUseCase.execute(guid: groupId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("List Get Fail : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    self?.groupUsers = response.data
                    self?.outputSubject.send(.getUserListSuccess)
                default:
                    debugPrint("List Get Fail")
                }
            }
            .store(in: &subscriptions)
    }
    
    private func groupUserAdd() {
        groupManagementUseCase.execute(receiveUserEmail: email, groupId: groupId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    debugPrint("Group User Add Fail: \(error)")
                    self?.outputSubject.send(.addEmailInputFail)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case .success:
                    self?.getGroupUsers()
                    self?.outputSubject.send(.addEmailInputSuccess)
                default:
                    self?.outputSubject.send(.addEmailInputFail)
                }
            }
            .store(in: &subscriptions)
    }
    
    // TODO: - 공통으로 빼기
    private func isAddEmailPossible() {
        if (3...40).contains(email.count) && isValidEmail(email) {
            outputSubject.send(.addEmailPossible)
        } else {
            outputSubject.send(.addEmailImpossible)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)

        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
}
