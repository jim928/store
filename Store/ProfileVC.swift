//
//  ProfileVC.swift
//  Store
//
//  Created by mac on 20/1/2021.
//

import UIKit
import SightKit

class ProfileVC: BaseVC ,UITableViewDelegate,UITableViewDataSource{
    var tableView:UITableView!
    var nameLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "个人中心"
        
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.className)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.csFullfillHorizontal().csBottom().csTop()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        
        let headView = UIView().addLine(edges: .bottom, color: grayLineColor, value: 1)
        headView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 150)
        tableView.tableHeaderView = headView
        let avatar = "avatar".toImgView().wBgColor(.white).addTo(headView).corner(radius: 35).border(width: 1, color: .gray).csCenterY().csLeft(40).csWidthHeight(70)
        nameLabel.wFeatures(pfm15,grayTextColor,headView).cstoRightOf(view: avatar, constant: 30).csCenterY()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUserInfo {
            self.nameLabel.text = appUserInfo?.username
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [30,44,44,44,20,44][indexPath.row]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 4{
            let cell = UITableViewCell()
            cell.contentView.backgroundColor = grayBgColor
            cell.addLine(edges: .bottom, color: grayLineColor, value: 1)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.className, for: indexPath) as! ProfileCell
        if indexPath.row == 1{
            cell.wImage(img: "", title: "个人信息", des: "")
        }
        if indexPath.row == 2{
            cell.wImage(img: "", title: "修改密码", des: "")
        }
        if indexPath.row == 3{
            cell.wImage(img: "", title: "修改手机", des: appUserInfo?.phone.orEmpty.desensitizeStr ?? "")
        }
        if indexPath.row == 5{
            cell.wImage(img: "", title: "我的会员", des: "普通会员")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            let vc = ChangePswVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class ProfileCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildViews()
    }
    
    var titleLabel = UILabel()
    var desLabel = UILabel()
    func buildViews() {
        wBgColor(.white)
        titleLabel.wFeatures(self,pfr16,grayTextColor).csCenterY().csLeft(20)
        desLabel.wFeatures(self,pfr14,grayTextColor).csCenterY().csRight(-35)
        "arrow-right-black".toImgView().addTo(self).csCenterY().csRight().csWidthHeight(35)
        addLine(edges: .bottom, color: grayLineColor, value: 1)
    }
    
    func wImage(img:String, title:String,des:String){
        titleLabel.text = title
        desLabel.text = des
    }

}
