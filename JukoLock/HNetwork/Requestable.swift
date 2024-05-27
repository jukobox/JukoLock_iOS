//
//  Requestable.swift
//  JukoLock
//
//  Created by 김경호 on 5/27/24.
//

import Combine
import Foundation

/// EndPoint를 사용해서 HTTP 요청시 구현해야 할 프로토콜
public protocol Requestable {
    func request<Target, Model>(_ target: Target) -> AnyPublisher<Model, HTTPError> where Target : EndPoint, Model: Decodable
}
