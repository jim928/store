//
//  HomeVC.swift
//  Store
//
//  Created by jim on 2021/1/16.
//

import UIKit
import SightKit
import SDWebImage

class HomeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Mall商城"
        // Do any additional setup after loading the view.
        
//        SKRq().wUrl("https://github.com/zhanqi/SightKit/blob/master/Example_iOS/back@2x.png?raw=true").resume { (result) in
//            print("success")
//        }
        self.view.backgroundColor = .gray
        let v = UIImageView().addTo(self.view).csCenter()//.csWidthHeight(60)
        v.sd_setImage(with: URL(string: "https://github.com/zhanqi/SightKit/blob/master/Example_iOS/back@2x.png?raw=true"), completed: nil)
        
        let av = "back".toImgView().addTo(self.view).csCenterX().cstoBottomOf(view: v,constant: 50)
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
