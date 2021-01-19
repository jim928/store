//
//  RegisterView.swift
//  Store
//
//  Created by mac on 19/1/2021.
//

import UIKit
import SightKit

class RegisterView: UIView {
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
        
        let logoView = UIView().csHeight(250)
        fView.fillSubView(view: logoView)
        "logo".toImgView().addTo(logoView).csCenter()
        
        let phoneNumView = EditCell()
        fView.fillSubView(view: phoneNumView, height: nil, verticalSpace: 0, leftSpace: 44, rightSpace: 44)
        phoneNumView.titleLabel.text = "手机号码"
        phoneNumView.textField.keyboardType = .numberPad

        let authCodeView = EditCell()
        fView.fillSubView(view: authCodeView, height: nil, verticalSpace: 22, leftSpace: 44, rightSpace: 44)
        authCodeView.titleLabel.text = "验证码"
        authCodeView.textField.keyboardType = .numberPad

        let getCodeView = SKGetVerifyCodeView().addTo(authCodeView).csRight().csFullfillVertical().csWidth(90)
        getCodeView.btn.addTargetClosure { (btn) in
            if let phoneNum = phoneNumView.textField.text, phoneNum.keepNumbers().count == 11 {
                showLoading()
                SKRq().wUrl(AppUrl.sso_getAuthCode.fullUrl).wParam(["telephone":phoneNum]).resume { (result) in
                    hideLoading()
                    if let code = result.json?["data"].stringValue,code.count == 6 {
                        getCodeView.start()
                        authCodeView.textField.text = code
                        showToast(toast: code)
                    }
                }
            }else {
                showToast(toast: "请输入正确的手机号")
            }
        }

        let userNameView = EditCell()
        fView.fillSubView(view: userNameView, height: nil, verticalSpace: 22, leftSpace: 44, rightSpace: 44)
        userNameView.titleLabel.text = "用户名"
        
        let pswView = EditCell()
        fView.fillSubView(view: pswView, height: nil, verticalSpace: 22, leftSpace: 44, rightSpace: 44)
        pswView.titleLabel.text = "密码"
        
        let shareCodeView = EditCell()
        fView.fillSubView(view: shareCodeView, height: nil, verticalSpace: 22, leftSpace: 44, rightSpace: 44)
        shareCodeView.titleLabel.text = "分享码"

        fView.fillSpace(33)
 
        let registBtnView = UIView().csHeight(40)
        fView.fillSubView(view: registBtnView)
        NextBtn().wTitle("注 册").addTo(registBtnView).csCenterX().csLeftRight(constant: 44).addAction {
            showLoading()
            SKRq().wUrl(AppUrl.sso_register.fullUrl).wPost().wParamInUrl().wParam(["authCode":authCodeView.textField.text.orEmpty,"password":pswView.textField.text.orEmpty,"shareCode":shareCodeView.textField.text.orEmpty,"telephone":phoneNumView.textField.text.orEmpty,"username":userNameView.textField.text.orEmpty]).resume { (result) in
                hideLoading()
                
                if let code = result.json?["code"].intValue,code == 200 {
                    SKRq().wUrl(AppUrl.sso_login.fullUrl).wParam(["password":pswView.textField.text.orEmpty,"username":userNameView.textField.text.orEmpty]).resume { (res) in
                        
                    }
                }else{
                    showToast(toast: result.json?["message"].stringValue)
                }
            }
        }

        fView.fillSpace(15)
        
        let loginBtnView = UIView().csHeight(40)
        fView.fillSubView(view: loginBtnView)
        UIButton().wFeatures("去登录",pfr14,loginBtnView,mainColor).csCenterX().csFullfillVertical().addAction {
            if let vc = self.viewController as? LoginRegisterVC {
                vc.showLoginView()
            }
        }
        
        fView.fillSpace(20)
        
        let footView = UIView().csHeight(74)
        fView.fillSubView(view: footView)
        "login-foot".toImgView().addTo(footView).csCenterX().csFullfillVertical()
        
        fView.fillSpace(60)

        UITextField.connectAllTxtFieldFields(txtfields: phoneNumView.textField,authCodeView.textField,userNameView.textField,pswView.textField)
    }
    

}
