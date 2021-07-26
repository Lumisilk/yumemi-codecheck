//
//  SearchRepositoriesResult.swift
//  iOSEngineerCodeCheck
//
//  Created by ribilynn on 2021/07/25.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Represent the result of searching repositories.
struct SearchRepositoriesResult: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let repositories: [Repository]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repositories = "items"
    }
}
