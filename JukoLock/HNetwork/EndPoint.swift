//
//  EndPoint.swift
//  JukoLock
//
//  Created by 김경호 on 5/27/24.
//

import Foundation

public protocol EndPoint {
    
    /// 요청하는 주소의 URL
    var baseURL: String { get }
    
    /// 요청할 때 필요한 headers를 담습니다.
    var headers: HTTPHeaders { get }
    
    /// 요청 시 필요한 parameter를 담당합니다.
    var parameter: HTTPParameter { get }
    
    /// http method 를 담당합니다.
    var method: HTTPMethod { get }
    
    /// 요청시 필요한 path를 담당합니다.
    var path: String { get }
    
}
