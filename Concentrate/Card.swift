//
//  Card.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/23.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    static var nextId = 0
    
    static func nextIdentifier() -> Int{
        Card.nextId = Card.nextId + 1
        return Card.nextId
    }
    
    init() {
        identifier = Card.nextIdentifier()
    }
}
