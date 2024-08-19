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
    private var email: String = ""
    var addEmails: [String] = []
    
    // TODO: - 친구 목록 가져오기
    
    // MARK: - Init
    
    init(createGroupUseCase: CreateGroupUseCaseProtocol) {
        self.createGroupUseCase = createGroupUseCase
    }
    
    // MARK: - Input
    
    enum Input {
        case groupCreateCompleteButtonTouched
        case groupNameInput(groupName: String)
        case addEmailInput(email: String)
        case addEmailButtonTouched
        case addEmailDelete(index: Int)
    }
    
    // MARK: - Output
    
    enum Output {
        case groupCreateComplete
        case groupCreateFail
        case createGroupPossible
        case createGroupImpossible
        case addEmailPossible
        case addEmailImpossible
        case addEmailInputSuccess
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
                case let .addEmailInput(email):
                    self?.email = email
                    self?.isAddEmailPossible()
                case .addEmailButtonTouched:
                    guard let email = self?.email else {
                        return
                    }
                    
                    self?.addEmails.append(email)
                    self?.outputSubject.send(.addEmailInputSuccess)
                case let .addEmailDelete(index):
                    self?.addEmails.remove(at: index)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func groupCreate() {
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
                    self?.userInvite()
                default:
                    self?.outputSubject.send(.groupCreateFail)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func userInvite() {
        if !addEmails.isEmpty {
            // TODO: - API 수정되면 하기
            debugPrint("API 호출")
        }
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
