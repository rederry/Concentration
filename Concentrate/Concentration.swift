//
//  Concentration.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/23.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [Card]()
    var indexOfOnlyOneFaceUp : Int?
    
    func choseCard(at index: Int) {
        if !cards[index].isMatched, !cards[index].isFaceUp {
            if let matchIndex = indexOfOnlyOneFaceUp, index != matchIndex{
                // match with the only one face up card
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                indexOfOnlyOneFaceUp = nil
            } else {
                // face down other card
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                indexOfOnlyOneFaceUp = index
            }
            cards[index].isFaceUp = true
        }
    }
    
    init(pairOfCards: Int) {
        for _ in 0..<pairOfCards {
            let newCard = Card()
            cards += [newCard, newCard] // Copy by value(value type) then a pair of card have the same identifier
        }
        shuffCards()
    }
    
    func shuffCards() {
        //Shuff cards
        for index in cards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(randomIndex, index)
        }
    }
}
