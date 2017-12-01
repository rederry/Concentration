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
        resetEmojiDict()
        choseRandomTheme()
        updateViewFromModel()
    }
    @IBOutlet private weak var newGameButton: UIButton!
    
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

    private var animalTheme = ("🐶🐹🐰🦊🐻🐼🐯🐷🦄🦆", #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))
    private var faceTheme = ("😄😂☺️😇😍😘🤪😱😡😎", #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    private var sportTheme = ("⚽️🏀🏈⚾️🎾🏐🎱🏓🏸🏒", #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    private var fruitTheme = ("🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈", #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1))
    private var toolTheme = ("⌚️📱💻⌨️🖥🖨🖱🖲🕹💣", #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1), #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))
    private var halloweenTheme = ("👻🎃🍬👹💀😈🤢💩👾🙀", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    private lazy var emojiThemes = [animalTheme, faceTheme, sportTheme, fruitTheme, toolTheme, halloweenTheme]
    
    private var emojis = String()
    
    override func viewDidLoad() {
        choseRandomTheme()
    }
    
    private var tintColor: UIColor {
        get {
            return flipCoutLable.textColor
        }
        set {
            for cardButton in cardButtons {
                cardButton.backgroundColor = newValue
            }
            scoreLable.textColor = newValue
            flipCoutLable.textColor = newValue
            newGameButton.setTitleColor(newValue, for: UIControlState.normal)
        }
    }
    
    private func choseRandomTheme() {
        let (emojiSet, bgColor, tintColor) = emojiThemes[emojiThemes.count.arc4random]
        emojis = emojiSet
        view.backgroundColor = bgColor
        self.tintColor = tintColor
    }
    
    private var emojiDict = [Card:String]()
    
    private func resetEmojiDict() {
        for val in emojiDict.values {
            emojis.append(val)
        }
        emojiDict = [Card:String]()
    }
    
    private func emoji(for card: Card) -> String {
        if emojiDict[card] == nil && emojis.count > 0 {
            let stringIndexOffset = emojis.index(emojis.startIndex, offsetBy: emojis.count.arc4random)
            emojiDict[card] = String(emojis.remove(at: stringIndexOffset))
        }
        return emojiDict[card] ?? "?"
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : tintColor
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
