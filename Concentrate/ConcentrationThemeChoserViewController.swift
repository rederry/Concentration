//
//  ConcentrationThemeChoserViewController.swift
//  Concentrate
//
//  Created by KangKang on 2017/12/26.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ConcentrationThemeChoserViewController: VCLLoggingViewController, UISplitViewControllerDelegate {
    
    override var vclLoggingName: String {
        return "ThemeChoser"
    }
    
    private var emojiThemes = [
        "animal" : ("🐶🐹🐰🦊🐻🐼🐯🐷🦄🦆", #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)),
        "face" : ("😄😂☺️😇😍😘🤪😱😡😎", #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
        "sport" : ("⚽️🏀🏈⚾️🎾🏐🎱🏓🏸🏒", #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)),
        "fruit" : ("🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈", #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)),
        "tool" : ("⌚️📱💻⌨️🖥🖨🖱🖲🕹💣", #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1), #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),
        "halloween" : ("👻🎃🍬👹💀😈🤢💩👾🙀", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    ]
    
    private var splitDetailViewConcentrationController: ConcentrationViewController? {
        return (splitViewController?.viewControllers.last as? UINavigationController)?.visibleViewController as? ConcentrationViewController
    }
    
    private var lastSeguedConcentrationViewController: ConcentrationViewController?
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return false
            }
        }
        return true
    }
    
    
    @IBAction func choseTheme(_ sender: Any) {
        if let cvc = splitDetailViewConcentrationController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                cvc.theme = emojiThemes[themeName]
                cvc.navigationItem.title = themeName
            }
        } else if let cvc = lastSeguedConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                cvc.theme = emojiThemes[themeName]
                cvc.navigationItem.title = themeName
                navigationController?.pushViewController(cvc, animated: true)
            }
        } else {
            performSegue(withIdentifier: "Chose Theme", sender: sender)            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle {
                if let cvc = (segue.destination as? UINavigationController)?.visibleViewController as? ConcentrationViewController {
                    cvc.theme = emojiThemes[themeName]
                    cvc.navigationItem.title = themeName
                    lastSeguedConcentrationViewController = cvc
                }
            }
        }
    }
}
