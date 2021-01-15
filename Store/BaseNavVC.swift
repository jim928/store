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
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: pfm18
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = UIColor(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
    }
}

