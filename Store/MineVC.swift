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

        UIView().addTo(levelLabel).csFullfill(top: -3, left: -5, bottom: 3, right: 5).corner(radius: 5).border(width: 1, color: .white)
        
        // Do any additional setup after loading the view.
        let fView = SKFillableView().addTo(self.view).csFullfill()
        fView.backgroundColor = grayBgColor
        
        fView.fillSpace(StatusBarHeight).wBgColor("313131".toColor)
        
        let headBg = UIView().csHeight(150).wBgColor("313131".toColor)
        fView.fillSubView(view: headBg)
        let avatar = "avatar".toImgView().wBgColor(.white).addTo(headBg).corner(radius: 35).border(width: 1, color: .gray).csCenterY().csLeft(40).csWidthHeight(70)
        nameLabel.wFeatures(pfm15,UIColor.white,headBg).cstoRightOf(view: avatar, constant: 30).csCenterY(-20)
        levelLabel.wFeatures(pfm15,UIColor.white,headBg).cstoRightOf(view: avatar, constant: 30).csCenterY(20)
        "arrow-right".toImgView().addTo(headBg).csCenterY().csRight(-10).csWidthHeight(30)
        let profileBtn = UIButton().wFeatures(headBg).csFullfill()
        profileBtn.addAction {
            let vc = ProfileVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let scoreBar = UIView().csHeight(60).wBgColor(.white)
        fView.fillSubView(view: scoreBar)
        scoreBar.divideHorizontal(num: 3) { (v, index) in
            UILabel().wFeatures(["积分","优惠券","关注"][index],pfr13,grayTextColor,v).csCenterX().csCenterY(-10)
            UILabel().wFeatures("100",pfm15,v,mainColor).csCenterX().csCenterY(10)
        }
        
        fView.fillSpace(20).wBgColor(grayBgColor).addLine(edges: .top,.bottom, color: grayLineColor, value: 1)
        
        let orderBar = UIView().csHeight(70).wBgColor(.white)
        fView.fillSubView(view: orderBar)
        orderBar.divideHorizontal(num: 5) { (v, index) in
            "icon-file".toImgView().addTo(v).csCenterX().csWidthHeight(35).csCenterY(-15)
            UILabel().wFeatures(["我的订单","待付款","待收货","待评价","售后服务"][index],pfr14,grayTextColor,v).csCenterX().csCenterY(15)
            UIButton().addTo(v).csFullfill().addAction {
                
            }
        }
        orderBar.addLine(edges: .bottom, color: grayLineColor, value: 1)
        
        let topicBar = UIView().csHeight(70).wBgColor(.white)
        fView.fillSubView(view: topicBar)
        topicBar.divideHorizontal(num: 4) { (v, index) in
            if (index == 0) {
                "icon-file".toImgView().addTo(v).csCenterX().csWidthHeight(35).csCenterY(-15)
            }else {
                UILabel().wFeatures("100",pfm15,v,grayTextColor).csCenterX().csCenterY(-15)
            }
            UILabel().wFeatures(["我的收藏","商品","专题","话题"][index],pfr14,grayTextColor,v).csCenterX().csCenterY(15)
        }
        
        fView.fillSpace(30).addLine(edges: .top,.bottom, color: grayLineColor, value: 1).wBgColor(grayBgColor)
        
        let trackCell = MeCell().csHeight(50)
        fView.fillSubView(view: trackCell)
        trackCell.wImage(img: "icon-file", title: "我的足迹", des: "10")
        
        let commitCell = MeCell().csHeight(50)
        fView.fillSubView(view: commitCell)
        commitCell.wImage(img: "icon-file", title: "我的评价", des: "10")

        let addressCell = MeCell().csHeight(50)
        fView.fillSubView(view: addressCell)
        addressCell.wImage(img: "icon-file", title: "地址管理", des: "")

        fView.fillSpace(10).wBgColor(grayBgColor).addLine(edges: .bottom, color: grayLineColor, value: 1)
        
        let memberCell = MeCell().csHeight(50)
        fView.fillSubView(view: memberCell)
        memberCell.wImage(img: "icon-file", title: "我的会员", des: "黄金会员")

        let serviceCell = MeCell().csHeight(50)
        fView.fillSubView(view: serviceCell)
        serviceCell.wImage(img: "icon-file", title: "服务中心", des: "")

        let settingCell = MeCell().csHeight(50)
        fView.fillSubView(view: settingCell)
        settingCell.wImage(img: "icon-file", title: "系统设置", des: "")

        fView.fillSpace(80)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        refreshUserInfo {
            self.nameLabel.text = appUserInfo?.username
            self.levelLabel.text = appUserInfo?.memberLevelId
            self.levelLabel.text = "黄金会员"
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

class MeCell: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    var imgView = UIImageView()
    var titleLabel = UILabel()
    var desLabel = UILabel()
    func buildViews() {
        wBgColor(.white)
        imgView.addTo(self).csCenterY().csWidthHeight(30).csLeft(20)
        titleLabel.wFeatures(self,pfr16,grayTextColor).csCenterY().cstoRightOf(view: imgView,constant: 10)
        desLabel.wFeatures(self,pfr14,grayTextColor).csCenterY().csRight(-65)
        "arrow-right-black".toImgView().addTo(self).csCenterY().csRight(-10).csWidthHeight(35)
        addLine(edges: .bottom, color: grayLineColor, value: 1)
    }
    
    func wImage(img:String, title:String,des:String){
        imgView.image = img.toImg()
        titleLabel.text = title
        desLabel.text = des
    }
}
