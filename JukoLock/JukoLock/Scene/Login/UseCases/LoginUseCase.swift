//
//  LoginUseCase.swift
//  JukoLock
//
//  Created by 김경호 on 5/27/24.
//

import Combine
import Foundation
import HNetwork

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) -> AnyPublisher<Never, HTTPError>
}

struct LoginUseCase: LoginUseCaseProtocol {
    
    private let probider: Requestable
    
    init(provider: ) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) -> AnyPublisher<Never, HTTPError> {
        return
    }
}
