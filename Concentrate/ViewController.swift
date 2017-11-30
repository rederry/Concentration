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
    
    private var pairOfCards: Int { // Already read-only
        return (cardButtons.count + 1) / 2
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.startNewGame()
        restoreEmojiDict()
        choseRandomEmojiTheme()
        updateViewFromModel()
    }
    
    @IBOutlet private weak var flipCoutLable: UILabel! // Outlets usually private
    
    @IBOutlet private weak var scoreLable: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {  // Internal implement
        if let cardNumber = cardButtons.index(of: sender) {
            game.choseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Error")
        }
    }

    private var animalEmojis = ["🐶", "🐹", "🐰", "🦊", "🐻", "🐼", "🐯", "🐷", "🦄", "🦆"]
    private var faceEmojis = ["😄", "😂", "☺️", "😇", "😍", "😘", "🤪", "😱", "😡", "😎"]
    private var sportEmojis = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🎱", "🏓", "🏸", "🏒"]
    private var fruitEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈"]
    private var toolEmojis = ["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "🖱", "🖲", "🕹", "💣"]
    private var flagEmojis = ["🇦🇷", "🇦🇪", "🇦🇼", "🇴🇲", "🇦🇿", "🇪🇬", "🇮🇪", "🇦🇩", "🇨🇳", "🇬🇧"]
    private lazy var emojiThemes = [animalEmojis, faceEmojis, sportEmojis, fruitEmojis, toolEmojis, flagEmojis]
    
    private lazy var emojis = emojiThemes[emojiThemes.count.arc4random]
    
    private func choseRandomEmojiTheme() {
        emojis = emojiThemes[emojiThemes.count.arc4random]
    }
    
    private var emojiDict = [Int:String]()
    
    private func restoreEmojiDict() {
        for val in emojiDict.values {
            emojis.append(val)
        }
        emojiDict = [Int:String]()
    }
    
    private func emoji(for card: Card) -> String {
        if emojiDict[card.identifier] == nil && emojis.count > 0 {
            emojiDict[card.identifier] = emojis.remove(at: emojis.count.arc4random)
        }
        return emojiDict[card.identifier] ?? "?"
    }
    
    //Handle view from model
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
        flipCoutLable.text = "Flip count: \(game.flipCount)" // Set flipCountLable and score
        scoreLable.text = "Score: \(game.score)"
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
