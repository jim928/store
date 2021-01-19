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

        self.navigationItem.title = "Mall商城"
        // Do any additional setup after loading the view.
        
//        SKRq().wUrl(AppUrl.sso_login.fullUrl).wPost().wParamInUrl().wParam(["username":"jack","password":"123123"]).resume { (result) in
//            let token = SKJSON()["data"]["token"].stringValue
//            print(token)
////            {
////            }
////            print(result.json["data"]["token"].str)
//        }
//        SKRq().wUrl(AppUrl.home_content.fullUrl).resume { (result) in
//
//        }
        
        UIButton().wBgColor(.green).addTo(self.view).csCenter().csWidthHeight(40).addAction {
            gotoLoginVC()
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
