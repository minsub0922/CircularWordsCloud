//
//  Keyword.swift
//  CircularWordsCloud
//
//  Created by 최민섭 on 2020/01/16.
//

import Foundation
internal struct Keyword {
    var text: String
    var rank: Int = 0
    var history: [String] = []
    var isSelected: Bool = false
}

