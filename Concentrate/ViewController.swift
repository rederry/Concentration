//
//  ViewController.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/22.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(pairOfCards: pairOfCards) // UIViewController's model usually public

    private(set) var flipCount = 0 {
        didSet {
            flipCoutLable.text = "Flip count: \(flipCount)"
        }
    }
    
    private var pairOfCards: Int { // Already read-only
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCoutLable: UILabel! // Outlets usually private
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {  // Internal implement
        flipCount += 1;
        if let cardNumber = cardButtons.index(of: sender) {
            game.choseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Error")
        }
    }

    private var emojis = ["🐶", "🤖", "🐸", "🦄", "🐵", "🐼", "🐙", "🦊", "🐷", "🐻", "🐰", "🐯", "🦁"]
    private var emojiDict = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emojiDict[card.identifier] == nil && emojis.count > 0 {
            emojiDict[card.identifier] = emojis.remove(at: emojis.count.arc4random)
        }
        return emojiDict[card.identifier] ?? "?"
    }
    
    //Handle view and model
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform((UInt32(self))))
        } else if self < 0 {
            return -Int(arc4random_uniform((UInt32(abs(self)))))
        } else {
            return 0
        }
    }
}
