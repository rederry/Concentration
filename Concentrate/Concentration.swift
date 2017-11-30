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
    
    private var indexOfOnlyOneFaceUp : Int? {
        get {
            var foundIndex :Int? // default nil
            for index in cards.indices {
                if cards[index].isFaceUp && foundIndex == nil {
                    foundIndex = index
                } else if cards[index].isFaceUp && foundIndex != nil {
                    return nil
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    private(set) var score = 0
    
    func startNewGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false;
            cards[index].isMatched = false;
        }
        shuffCards()
        flipCount = 0
        score = 0
        mismatchedCards = Set<Int>()
    }
    
    func choseCard(at index: Int) {
        if !cards[index].isMatched, !cards[index].isFaceUp {
            if let matchIndex = indexOfOnlyOneFaceUp, index != matchIndex{
                // match with the only one face up card
                if cards[index].identifier == cards[matchIndex].identifier {
                    // matched
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    score += 2
                } else { // mismatch update score
                    if (mismatchedCards.contains(cards[index].identifier)) {
                        score -= 1
                    }
                    if (mismatchedCards.contains(cards[matchIndex].identifier)) {
                        score -= 1
                    }
                    mismatchedCards.insert(cards[index].identifier)
                    mismatchedCards.insert(cards[matchIndex].identifier)
                }
                cards[index].isFaceUp = true
            } else {
                // face down other card
                indexOfOnlyOneFaceUp = index
            }
            flipCount += 1
        }
    }
    
    private var mismatchedCards = Set<Int>()
    
    init(pairOfCards: Int) {
        for _ in 0..<pairOfCards {
            let newCard = Card()
            cards += [newCard, newCard] // Copy by value(value type) then a pair of card have the same identifier
        }
        shuffCards()
    }
    
    private func shuffCards() {
        for index in cards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(randomIndex, index)
        }
    }
}
