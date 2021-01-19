//
//  LoginView.swift
//  Store
//
//  Created by mac on 19/1/2021.
//

import UIKit
import SightKit

class LoginView: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    func buildViews() {
        let fView = SKFillableView().addTo(self).csFullfill()
        if #available(iOS 11.0, *) {
            fView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }

        fView.fillSpace(StatusBarHeight)
        
        let backView = UIView().csHeight(44)
        fView.fillSubView(view: backView)
        UIButton().wFeatures("btn-close".toImg(),backView).csRight(-10).csFullfillVertical().csWidth(44).addAction {
            gotoTabbarVC()
        }
        
        let logoView = UIView().csHeight(300)
        fView.fillSubView(view: logoView)
        "logo".toImgView().addTo(logoView).csCenter()
        
        let userNameView = EditCell()
        fView.fillSubView(view: userNameView, height: nil, verticalSpace: 0, leftSpace: 44, rightSpace: 44)
        userNameView.titleLabel.text = "用户名"
        userNameView.textField.text = appUserName
        
        fView.fillSpace(22)
        
        let pswView = EditCell()
        fView.fillSubView(view: pswView, height: nil, verticalSpace: 0, leftSpace: 44, rightSpace: 44)
        pswView.titleLabel.text = "密码"
        pswView.textField.isSecureTextEntry = true
        
        fView.fillSpace(33)
        
        let loginBtnView = UIView().csHeight(40)
        fView.fillSubView(view: loginBtnView)
        NextBtn().wTitle("登 录").addTo(loginBtnView).csCenterX().csLeftRight(constant: 44).addAction {
            showLoading()
            loginWith(userName: userNameView.textField.text.orEmpty, passWord: pswView.textField.text.orEmpty) { (res) in
                hideLoading()
                if res.success {
                    showToast(toast: "登录成功")
                    gotoTabbarVC()
                }else{
                    showToast(toast: res.errorMsg)
                }
            }
        }
        
        fView.fillSpace(15)
        
        let registBtnView = UIView().csHeight(40)
        fView.fillSubView(view: registBtnView)
        UIButton().wFeatures("去注册",pfr14,registBtnView,mainColor).csCenterX().csFullfillVertical().addAction {
            if let vc = self.viewController as? LoginRegisterVC {
                vc.showRegisterView()
            }
        }

        fView.fillSpace(20)
        
        let footView = UIView().csHeight(74)
        fView.fillSubView(view: footView)
        "login-foot".toImgView().addTo(footView).csCenterX().csFullfillVertical()
        
        fView.fillSpace(60)
        
        UITextField.connectAllTxtFieldFields(txtfields: userNameView.textField,pswView.textField)
    }
}

class EditCell: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    var titleLabel = UILabel()
    var textField = UITextField()
    func buildViews() {
        self.csHeight(44)
        titleLabel.wFeatures(pfr12,mainColor,self).csTop().csLeft()
        textField.wFeatures(pfr16,mainColor,self).csFullfillHorizontal().csBottom().csTop(10)
        UIView().addTo(self).wBgColor(mainColor).csBottom().csFullfillHorizontal().csHeight(1)
    }
}

class NextBtn: UIButton {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    func buildViews() {
        self.wTitleColor(.white).wFont(pfm16)
        self.csHeight(40).corner(radius: 20)
        setBackgroundColor(mainColor, for: .normal)
    }
}
