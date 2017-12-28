//
//  ViewController.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/22.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(pairOfCards: pairOfCards) // UIViewController's model usually public
    
    private var pairOfCards: Int { // Already read-only
        return (cardButtons.count + 1) / 2
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.startNewGame() // Change model
        updateViewFromModel()
    }
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private weak var flipCoutLable: UILabel! { // Outlets usually private
        didSet { // Set by UIViewController
            updateFlipCountLable()
        }
    }
    
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
    
    override func viewDidLoad() {
//        theme = ("👻🎃🍬👹💀😈🤢💩👾🙀", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    }
    
    var theme: (String, UIColor, UIColor)? {
        didSet {
            resetEmojiDict()
            if let (emojiSet, bgColor, tintColor) = theme {
                emojis = emojiSet
                // MARK: - !!!!!! prepare(for segue) use viewController.view will set all outlets!(don't know why)
                view.backgroundColor = bgColor
                self.tintColor = tintColor
                updateViewFromModel()
            }
        }
    }
    private var emojis = String()
    
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
        updateFlipCountLable()
        scoreLable.text = "Score: \(game.score)"
    }
    
    private func updateFlipCountLable() {
        let attrs: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeWidth : 5
        ]
        let attrsText = NSAttributedString(string: "Flip count: \(game.flipCount)", attributes: attrs)
        flipCoutLable.attributedText = attrsText
    }
}
