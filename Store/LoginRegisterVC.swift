//
//  LoginRegisterVC.swift
//  Store
//
//  Created by mac on 19/1/2021.
//

import UIKit

class LoginRegisterVC: BaseVC {
    
    var lView = LoginView()
    var rView = RegisterView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lView.addTo(self.view).csFullfill()
        rView.addTo(self.view).csFullfill()
        
        rView.isHidden = true
    }
    func showLoginView(){
        lView.isHidden = false
        rView.isHidden = true
    }
    func showRegisterView(){
        lView.isHidden = true
        rView.isHidden = false
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
