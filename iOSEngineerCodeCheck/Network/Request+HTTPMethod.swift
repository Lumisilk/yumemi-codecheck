//
//  Request.swift
//  iOSEngineerCodeCheck
//
//  Created by ribilynn on 2021/07/24.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Request {
    associatedtype Response: Decodable
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}
