//
//  InvitationListViewModel.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Combine
import Foundation

final class InvitationListViewModel {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var invitationListUseCase: InvitationListUseCaseProtocol
    var noties: [Invite]
    
    // TODO: - 친구 목록 가져오기
    
    // MARK: - Init
    
    init(invitationListUseCase: InvitationListUseCase, noties: [Invite]) {
        self.invitationListUseCase = invitationListUseCase
        self.noties = noties
    }
    
    // MARK: - Input
    
    enum Input {
        case invitationAccept(index: Int)
    }
    
    // MARK: - Output
    
    enum Output {
        case invitationAcceptSuccess
        case invitationAcceptFail
        case invitationAcceptError
    }
}

// MARK: - Methods

extension InvitationListViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .invitationAccept(index):
                    self?.invitationAccept(index: index)
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func invitationAccept(index: Int) {
        invitationListUseCase.execute(invitationId: noties[index].id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    debugPrint("Accept Fail! : ", error)
                }
            } receiveValue: { [weak self] response in
                switch response.status {
                case "success":
                    self?.noties.remove(at: index)
                    self?.outputSubject.send(.invitationAcceptSuccess)
                case "fail":
                    self?.outputSubject.send(.invitationAcceptFail)
                default:
                    self?.outputSubject.send(.invitationAcceptError)
                }
            }
            .store(in: &subscriptions)
    }
}
