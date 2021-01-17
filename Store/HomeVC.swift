//
//  HomeVC.swift
//  Store
//
//  Created by jim on 2021/1/16.
//

import UIKit
import SightKit

class HomeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        SKRq().wUrl(AppUrl.sso_login.fullUrl).wPost().wHeader(["accept":"*/*"]).wParam(["username":"15002066006","password":"123123"]).resume { (result) in
//
//        }
        SKRq().wUrl(AppUrl.home_content.fullUrl).resume { (result) in
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
