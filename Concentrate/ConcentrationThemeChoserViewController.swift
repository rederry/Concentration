//
//  ConcentrationThemeChoserViewController.swift
//  Concentrate
//
//  Created by KangKang on 2017/12/26.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ConcentrationThemeChoserViewController: UIViewController {
    
    private var emojiThemes = [
        "animal" : ("🐶🐹🐰🦊🐻🐼🐯🐷🦄🦆", #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)),
        "face" : ("😄😂☺️😇😍😘🤪😱😡😎", #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
        "sport" : ("⚽️🏀🏈⚾️🎾🏐🎱🏓🏸🏒", #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)),
        "fruit" : ("🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈", #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)),
        "tool" : ("⌚️📱💻⌨️🖥🖨🖱🖲🕹💣", #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1), #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),
        "halloween" : ("👻🎃🍬👹💀😈🤢💩👾🙀", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    ]
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Chose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle {
                if let desVC = segue.destination as? ConcentrationViewController {
                    desVC.theme = emojiThemes[themeName]
                }
            }
        }
    }
}
