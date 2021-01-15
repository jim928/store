//
//  SKFillableView.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/22.
//

import Foundation

/// 以堆栈的思想填充列view
open class SKFillableView: UIView {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    
    public var mainView: UIView!
    public var scrollView: UIScrollView!
    public var contentView: UIView!
    
    public var dismissBtn: UIButton!
    
    public func buildViews() {
        mainView = UIView()
        self.addSubview(mainView)
        mainView.csFullfill()

        dismissBtn = UIButton()
        mainView.addSubview(dismissBtn)
        dismissBtn.csFullfill()
        dismissBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        scrollView = UIScrollView()
//        scrollView.delaysContentTouches = false //让内部的按钮 点击立即能改变背景颜色 但是当内部满是（UIButton，UITextField）等control的时候会导致scrollview无法滚动
        mainView.addSubview(scrollView)
        scrollView.csFullfill()
        
        contentView = UIView()//高度由内部view决定
        scrollView.addSubview(contentView)
        contentView.csFullfill().csWidth(scrollView)
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self](notification) in
            let userInfo: NSDictionary = notification.userInfo! as NSDictionary
            let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
            let keyboardRec = (value as AnyObject).cgRectValue
            let height:CGFloat = keyboardRec?.size.height ?? 0
            self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self](notification) in
            self?.scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    @objc func dismissAction(){
        self.endEditing(true)
    }
    
    //穿透点击事件 使得可以点击空处解散键盘
//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if let view = super.hitTest(point, with: event){
//            if view.className == "UIView" || view.className == "UIScrollView"{
//                if let superView = view.superview {
//                    if superView is UICollectionViewCell || superView is UITableViewCell{
//                        return view
//                    }
//                }
//                return self.dismissBtn
//            }
//        }
//        return super.hitTest(point, with: event)
//    }
    
    public var lastView: UIView?
    
    /// Fill a subview ,the height of it depends on its contents, so make sure constraints inside is completed
    /// - Parameter view: the view will be filled
    public func fillSubView(view: UIView) {
        self.fillSubView(view: view, height: nil, verticalSpace: 0, leftSpace: 0, rightSpace: 0)
    }
    
    /// Fill a subview
    /// - Parameters:
    ///   - view: the view will be filled
    ///   - height: the height of the view, if nil, then make sure its content constriants is completed
    ///   - verticalSpace: the space to the last view filled or the superView
    ///   - leftSpace: left margin
    ///   - rightSpace: right margin,give a positive value
    public func fillSubView(view: UIView,height:CGFloat?,verticalSpace:CGFloat,leftSpace:CGFloat,rightSpace:CGFloat) {
        contentView.addSubview(view)
        
        view.csLeft(leftSpace).csRight(-rightSpace)
        if let lastView = lastView{
            view.cstoBottomOf(view: lastView,constant: verticalSpace)
        }else{
            view.csTop(verticalSpace)
        }
        
        if let height = height {
            view.csHeight(height)
        }
        view.csBottomLessThanOrEqual()
        
        lastView = view
    }
    
    @discardableResult public func fillSpace(_ height:CGFloat) -> UIView{
        let view = UIView().csHeight(height)
        self.fillSubView(view: view)
        return view
    }
    
    public func clearAll(){
        self.contentView.removeAllSubviews()
        self.lastView = nil
    }
}

