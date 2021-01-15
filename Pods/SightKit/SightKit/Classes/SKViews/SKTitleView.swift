//
//  SKTitleView.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/22.
//

import Foundation

/*
 let sView = SKTitleView().addTo(self.view).csCenterY().csFullfillHorizontal().csHeight(60)
 sView.setTitles(titles: ["btn1","btn2","btn3","btn4","btn5","btn6","btn7","btn7","btn7","btn7","btn7","btn7","btn7","btn7","btn7"], selectIndex: 2, titleBtnConfig: { (btn, text, index) in
     btn.wFeatures(UIColor.black,pfr12)
     btn.setTitleColor(.green, for: .selected)
 }) { (index) in
     print(index)
 }
 
 sView.addLeftBtn(width: 80, configBtn: { (btn) in
     btn.wFeatures("btn",UIColor.red,pfr14)
 }, tapClosure: { (btn) in
     print("left tap")
 })

 sView.addRightView(width: 50) { (rightView) in
     rightView.backgroundColor = .red
 }
 */

/// A view with many titles by default, you can add leftView,rightView, leftBtn, rightBtn if needed.
open class SKTitleView: UIView {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    public var titles:[String] = []
    public var btns:[UIButton]! = []
    public var selectBtn:UIButton?
    var titleTapClosure:((Int)->Void)?
    
    public var scrollView:UIScrollView!
    var contentView:UIView!
    public var csScrollViewLeft:NSLayoutConstraint!
    public var csScrollViewRight:NSLayoutConstraint!
        
    public var leftBtn:UIButton?
    public var rightBtn:UIButton?

    public var leftView:UIView?
    public var rightView:UIView?
    
    func buildViews() {
        scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.csFullfillVertical()
        scrollView.showsHorizontalScrollIndicator = false
        
        csScrollViewLeft = scrollView.csLeft().lastCS!
        csScrollViewRight = scrollView.csRight().lastCS!
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.csFullfill().csHeight(self)
    }
    
    /// set titles of the view
    /// - Parameters:
    ///   - titles: titles
    ///   - selectIndex: default index selected, set 0 if it is out of range
    ///   - titleBtnConfig: configure title and image of the btn
    ///   - titleTap: tap event , if you want to use add target , add it in titleBtnConfig
    /// - Returns: return
    public func setTitles(titles:[String],selectIndex:UInt,titleBtnConfig:((UIButton,String,Int)->()),titleTap: ((Int)->())?){
        guard titles.count > 0 else {
            return
        }
        self.titleTapClosure = titleTap
        
        contentView.removeAllSubviews()
        selectBtn = nil
        
        let defaultIndex = selectIndex >= titles.count ? 0 : selectIndex
        self.titles = titles
        var lastBtn:UIButton?
        for (i,str) in titles.enumerated() {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.tag = i
            if let _ = titleTap {
                btn.addTarget(self, action: #selector(titleTap(btn:)), for: .touchUpInside)
            }
            titleBtnConfig(btn,str,i)
            
            if i == defaultIndex {
                btn.isSelected = true
                selectBtn = btn
            }
            
            contentView.addSubview(btn)
            btn.csTo(attrs: .top,.bottom)
            if lastBtn == nil {
                btn.csLeft()
            }else{
                btn.cstoRightOf(view: lastBtn!)
            }
            if i == titles.count-1{
                btn.csRight()
            }
            btn.csWidth(btn.intrinsicContentSize.width+20)
            
            btns.append(btn)
            lastBtn = btn
        }
    }
    
    @objc func titleTap(btn:UIButton){
        if selectBtn?.tag == btn.tag { return }
        
        selectBtn?.isSelected = false
        
        selectBtn = btn
        selectBtn?.isSelected = true
        
        //防止左右滚动越界
        var toX = btn.frame.origin.x-scrollView.frame.size.width/2+btn.frame.size.width/2
        toX = max(0, toX)
        if toX+scrollView.frame.size.width > scrollView.contentSize.width {
            toX = scrollView.contentSize.width - scrollView.frame.size.width
        }
        if scrollView.contentSize.width>scrollView.frame.width{
            scrollView.setContentOffset(CGPoint(x: toX, y: 0), animated: true)
        }
        
        self.titleTapClosure?(btn.tag)
    }
    
    /// add leftBtn
    /// - Parameters:
    ///   - width: the width of leftBtn
    ///   - configBtn: configure title and image here
    ///   - tapClosure: tap event,if you want use add target, add it in configBtn
    public func addLeftBtn(width:CGFloat,configBtn:((UIButton)->()),tapClosure:UIButtonTargetClosure?){
        self.leftView?.removeFromSuperview()
        
        leftBtn = UIButton().addTo(self).csLeft().csFullfillVertical().csWidth(width)
        if let tapClosure = tapClosure {
            leftBtn?.addTargetClosure(closure: tapClosure)
        }
        configBtn(leftBtn!)
        self.csScrollViewLeft.constant = width
    }
    
    /// add rightBtn
    /// - Parameters:
    ///   - width: the width of rightBtn
    ///   - configBtn: configure title and image here
    ///   - tapClosure: tap event,if you want use add target, add it in configBtn
    public func addRightBtn(width:CGFloat,configBtn:((UIButton)->()),tapClosure:UIButtonTargetClosure?){
        self.rightView?.removeFromSuperview()
        
        rightBtn = UIButton().addTo(self).csRight().csFullfillVertical().csWidth(width)
        if let tapClosure = tapClosure {
            rightBtn?.addTargetClosure(closure: tapClosure)
        }
        configBtn(rightBtn!)
        self.csScrollViewRight.constant = -width
    }
    
    /// add leftView
    /// - Parameters:
    ///   - width: width of leftView
    ///   - config: configure leftView and its subviews
    /// - Returns: return
    public func addLeftView(width:CGFloat,config:((UIView)->())){
        self.leftBtn?.removeFromSuperview()
        
        leftView = UIView().addTo(self).csLeft().csFullfillVertical().csWidth(width)
        config(leftView!)
        self.csScrollViewLeft.constant = width
    }
    
    /// add rightView
    /// - Parameters:
    ///   - width: width of rightView
    ///   - config: configure rightView and its subviews
    /// - Returns: return
    public func addRightView(width:CGFloat,config:((UIView)->())){
        self.rightBtn?.removeFromSuperview()
        
        rightView = UIView().addTo(self).csRight().csFullfillVertical().csWidth(width)
        config(rightView!)
        self.csScrollViewRight.constant = -width
    }

}
