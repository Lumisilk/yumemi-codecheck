//
//  CountFormatter.swift
//  iOSEngineerCodeCheck
//
//  Created by ribilynn on 2021/07/27.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

func formatCount(count: Int) -> String {
    if count < 1000 {
        return String(count)
    } else {
        return String(format: "%.1fk", Double(count) / 1000)
    }
}
