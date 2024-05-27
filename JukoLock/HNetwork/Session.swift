//
//  Session.swift
//  JukoLock
//
//  Created by 김경호 on 5/27/24.
//

import Foundation

public protocol Session {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

// MARK: - URLSession + Session

extension URLSession: Session {
}
