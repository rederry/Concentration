//
//  ConcentrationThemeChoserViewController.swift
//  Concentrate
//
//  Created by KangKang on 2017/12/26.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class ConcentrationThemeChoserViewController: UIViewController {
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.        
        if let desVC = segue.destination as? ConcentrationViewController {
            if let identifier = segue.identifier {
                desVC.choseTheme(with: identifier)
            }
        }
    }
}
