//
//  ChangePswVC.swift
//  Store
//
//  Created by mac on 20/1/2021.
//

import UIKit
import SightKit

class ChangePswVC: BaseVC {

    var phoneField:UITextField!
    var authCodeField:UITextField!
    var newPswField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "修改密码"
        let rightBtn = UIButton().wFeatures("完成",pfr15,UIColor.white).wFrame(CGRect.init(x: 0, y: 0, width: 50, height: 44))
        rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
        rightBtn.addAction {
            self.view.endEditing(true)
            
            showLoading()
            SKRq().wUrl(AppUrl.sso_updatePassword.fullUrl).wPost().wParamInUrl().wParam(["authCode":self.authCodeField.text.orEmpty,"password":self.newPswField.text.orEmpty,"telephone":self.phoneField.text.orEmpty]).resume { (result) in
                hideLoading()
                
                if (result.success){
                    showToast(toast: "修改成功")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    showToast(toast: result.errorMsg)
                }
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)

        self.view.backgroundColor = grayBgColor
        
        self.view.addSubviewVerticalSpace(height: 20)?.addLine(edges: .bottom, color: grayLineColor, value: 1)
        
        self.view.addSubviewVertical { (v) in
            let cell = EditCellChangePsw().addTo(v).csFullfill()
            cell.wTitle(title: "手机号", placeholde: "")
            cell.textField.text = appUserInfo?.phone
            phoneField = cell.textField
        }
        
        self.view.addSubviewVertical { (v) in
            let cell = EditCellChangePsw().addTo(v).csFullfill()
            cell.wTitle(title: "验证码", placeholde: "请输入验证码")
            authCodeField = cell.textField
            
            let getCodeView = SKGetVerifyCodeView().addTo(cell).csRight().csFullfillVertical().csWidth(90)
            getCodeView.btn.addTargetClosure { (btn) in
                if let phoneNum = appUserInfo?.phone, phoneNum.keepNumbers().count == 11 {
                    showLoading()
                    SKRq().wUrl(AppUrl.sso_getAuthCode.fullUrl).wParam(["telephone":phoneNum]).resume { (result) in
                        hideLoading()
                        if let code = result.json?["data"].stringValue,code.count == 6 {
                            getCodeView.start()
                            cell.textField.text = code
                            showToast(toast: code)
                        }
                    }
                }else {
                    showToast(toast: "请输入正确的手机号")
                }
            }
        }

        self.view.addSubviewVertical { (v) in
            let cell = EditCellChangePsw().addTo(v).csFullfill()
            cell.wTitle(title: "新密码", placeholde: "请输入新密码（6-20位数字或字母）")
            newPswField = cell.textField
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

class EditCellChangePsw: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    var textField = UITextField()
    func buildViews() {
        csHeight(50)
        wBgColor(.white)
        textField.addTo(self).wFont(pfr14).csFullfill()
        addLine(edges: .bottom, color: grayLineColor, value: 1)
    }
    func wTitle(title:String,placeholde:String){
        textField.addLeftView(width: 90) { (v) in
            UILabel().wFeatures(title,pfr15,grayTextColor,v).csLeft(20).csCenterY()
        }
        textField.wPlaceholder(text: placeholde, color: grayLineColor, font: pfr14)
    }
}
