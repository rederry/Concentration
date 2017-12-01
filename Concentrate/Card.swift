//
//  Card.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/23.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int // Usually private
    private static var identifierFactory = 0
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static func nextIdentifier() -> Int{
        Card.identifierFactory = Card.identifierFactory + 1
        return Card.identifierFactory
    }
    
    init() {
        identifier = Card.nextIdentifier()
    }
}
