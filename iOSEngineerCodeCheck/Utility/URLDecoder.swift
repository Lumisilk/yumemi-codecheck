//
//  URLDecoder.swift
//  iOSEngineerCodeCheck
//
//  Created by ribilynn on 2021/07/26.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

@propertyWrapper
struct URLDecoder: Decodable {
    var wrappedValue: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let str = try? container.decode(String.self),
           let encoded = str.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded) {
            self.wrappedValue = url
        } else {
            wrappedValue = nil
        }
    }
}
