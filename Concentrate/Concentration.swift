//
//  Concentration.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/23.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import Foundation

struct Concentration {
    
    var cards = [Card]()
    
    private var indexOfOnlyOneFaceUp : Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
//            let faceUpIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpIndices.count == 1 ? faceUpIndices.first : nil
            
//            let filtedCards = cards.filter{ $0.isFaceUp }
//            return (filtedCards.count == 1) ? cards.index(of: filtedCards.first!) : nil
            
//            var foundIndex :Int? // default nil
//            for index in cards.indices {
//                if cards[index].isFaceUp && foundIndex == nil {
//                    foundIndex = index
//                } else if cards[index].isFaceUp && foundIndex != nil {
//                    return nil
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    private(set) var score = 0
    private var mismatchedCards = Set<Card>()
    
    mutating func startNewGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false;
            cards[index].isMatched = false;
        }
        shuffCards()
        flipCount = 0
        score = 0
        mismatchedCards = Set<Card>()
        lastMatchTime = Date()
    }
    
    private var lastMatchTime = Date()
    
    mutating func choseCard(at index: Int) {
        if !cards[index].isMatched, !cards[index].isFaceUp {
            if let matchIndex = indexOfOnlyOneFaceUp, index != matchIndex{
                // match with the only one face up card
                if cards[index] == cards[matchIndex] {
                    // matched
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    let time = Date().timeIntervalSince(lastMatchTime)
                    var bonus = 0
                    switch time {
                    case 0..<3:
                         bonus = 2
                    case 3..<5:
                         bonus = 1
                    case 5..<10:
                         bonus = 0
                    default:
                         bonus = -1
                    }
                    score += 2 + bonus
                    lastMatchTime = Date()
                } else { // mismatch update score
                    if (mismatchedCards.contains(cards[index])) {
                        score -= 1
                    }
                    if (mismatchedCards.contains(cards[matchIndex])) {
                        score -= 1
                    }
                    mismatchedCards.insert(cards[index])
                    mismatchedCards.insert(cards[matchIndex])
                }
                cards[index].isFaceUp = true
            } else {
                // face down other card
                indexOfOnlyOneFaceUp = index
            }
            flipCount += 1
        }
    }
    
    init(pairOfCards: Int) {
        for _ in 0..<pairOfCards {
            let newCard = Card()
            cards += [newCard, newCard] // Copy by value(value type) then a pair of card have the same identifier
        }
        shuffCards()
    }
    
    private mutating func shuffCards() {
        for index in cards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(randomIndex, index)
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return self.count == 1 ? self.first : nil
    }
}
