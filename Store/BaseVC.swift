//
//  BaseVC.swift
//  Store
//
//  Created by jim on 2021/1/16.
//

import UIKit
import SightKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        if let nav = self.navigationController{
            if self != nav.viewControllers.first {
                let leftBtn = UIButton(type: .custom)
                leftBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
                leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
                let backImg = "back".toImgView()
                backImg.frame = CGRect(x: -10, y: 5, width: 34, height: 34) //根据图片调整位置大小
                leftBtn.addSubview(backImg)
                backImg.contentMode = .scaleAspectFit
                let leftBarBtn = UIBarButtonItem(customView: leftBtn)
                self.navigationItem.leftBarButtonItem = leftBarBtn
            }
        }
    }
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
}

