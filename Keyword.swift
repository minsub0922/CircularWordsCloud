//
//  Keyword.swift
//  CircularWordsCloud
//
//  Created by 최민섭 on 2020/01/17.
//

internal struct Keyword {
    var text: String
    var rank: Int = 0
    var history: [String] = []
    var isSelected: Bool = false
}
