//
//  SKGetVerifyCodeView.swift
//  SightKit
//
//  Created by mac on 24/10/2020.
//

import Foundation

/** 获取验证码 控件，放在UITextfield右边
 ## 使用示例
 ```
 let getCodeView = SKGetVerifyCodeView()
 codeField.addRightView(width: 93, view: getCodeView)
 getCodeView.btn.addTargetClosure { (btn) in
     getCodeView.start()
 }
 */
open class SKGetVerifyCodeView: UIView {
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    public var btn = UIButton()
    public var font:UIFont! { didSet{ self.btn.wFont(font) } }
    public var titleColor:UIColor! { didSet{ self.btn.wTitleColor(titleColor) } }
    public var title:String! { didSet { self.btn.wTitle(title) } }
    public var disableColor:UIColor! { didSet { self.btn.setTitleColor(disableColor, for: .disabled) } }
    
    public var timer:Timer?
    public var count = 30 { didSet { privateCount = count } }
    var privateCount = 30
    func buildViews() {
        btn.addTo(self).csFullfill()
        
        font = pfr14
        titleColor = UIColor.init(hex: 0xD29341)
        title = "获取验证码"
        disableColor = UIColor.init(hex: 0xBEBEBE)
    }
    public func start(){
        btn.isEnabled = false
        
        btn.setTitle("\(privateCount)", for: .disabled)
        if let timer = timer {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: false)
    }
    @objc func countDown(){
        if privateCount > 0 {
            privateCount-=1
            btn.setTitle("\(privateCount)", for: .disabled)
            if let timer = timer {
                timer.invalidate()
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: false)
        }else{
            privateCount = count
            btn.isEnabled = true
        }
    }
}
