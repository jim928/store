//
//  BaseNavVC.swift
//  Store
//
//  Created by jim on 2021/1/16.
//

import UIKit
import SightKit
class BaseNavVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: pfm18
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = mainColor
        UINavigationBar.appearance().isTranslucent = false
    }
}

