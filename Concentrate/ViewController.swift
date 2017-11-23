//
//  ViewController.swift
//  Concentrate
//
//  Created by KangKang on 2017/11/22.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var flipCount = 0 {
        didSet {
            flipCoutLable.text = "Flip count: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCoutLable: UILabel! 
    
    @IBOutlet var cardButtons: [UIButton]!
    var emojis = ["🐶", "🤖", "🤖", "🐶",]
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1;
        let cardNumber = cardButtons.index(of: sender)!;
        flipCard(on: sender, withEmoji: emojis[cardNumber])
    }
    
    func flipCard(on sender: UIButton, withEmoji emoji: String) {
        if sender.currentTitle == emoji {
            sender.setTitle("", for: UIControlState.normal)
            sender.backgroundColor = UIColor.white
        } else {
            sender.setTitle(emoji, for: UIControlState.normal)
            sender.backgroundColor = UIColor.orange
        }
    }


}

