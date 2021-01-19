//
//  MineVC.swift
//  Store
//
//  Created by jim on 2021/1/16.
//

import UIKit
import SightKit

class MineVC: BaseVC {

    var nameLabel = UILabel()
    var levelLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fView = SKFillableView().addTo(self.view).csFullfill()
        
        fView.fillSpace(StatusBarHeight).wBgColor("313131".toColor)
        
        let headBg = UIView().csHeight(150).wBgColor("313131".toColor)
        fView.fillSubView(view: headBg)
        let avatar = "avatar".toImgView().wBgColor(.white).addTo(headBg).corner(radius: 35).border(width: 1, color: .gray).csCenterY().csLeft(60).csWidthHeight(70)
        nameLabel.wFeatures(pfm15,UIColor.white,headBg).cstoRightOf(view: avatar, constant: 50).csCenterY(-20)
        levelLabel.wFeatures(pfm15,UIColor.white,headBg).cstoRightOf(view: avatar, constant: 50).csCenterY(20)
        let profileBtn = UIButton().wFeatures(headBg).csRight(-10).csCenterY().csWidthHeight(60)
        profileBtn.addAction {
            
        }
        "arrow-right".toImgView().addTo(profileBtn).csCenter().csWidthHeight(30)
        
        let scoreBar = UIView().csHeight(60)
        fView.fillSubView(view: scoreBar)
        scoreBar.divideHorizontal(num: 3) { (v, index) in
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        refreshUserInfo {
            self.nameLabel.text = appUserInfo?.username
            self.levelLabel.text = appUserInfo?.memberLevelId
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
