//
//  Toast+Loading.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation

public let tagForToastView = 2020001
public let tagForLoadingView = 2020002

public var skDefaultLoadingText = "加载中..."

public func showToast(toast:String?,fromView: UIView?=nil,duration:TimeInterval=1.5){
    guard let fromView = fromView ?? UIApplication.shared.keyWindow else {
        print("cannot make toast for there is no fatherView or window")
        return
    }
    guard let toast = toast else {
        print("toast string is null ,nothing to show")
        return
    }
    
    DispatchQueue.main.async {
        //防止重复添加
        if let existToastView = fromView.viewWithTag(tagForToastView) {
            existToastView.removeFromSuperview()
        }
        
        let containView = UIView()
        containView.tag = tagForToastView
        fromView.addSubview(containView)
        containView.csFullfill()
        
        let shadowBg = UIView()
        containView.addSubview(shadowBg)
        shadowBg.backgroundColor = .black
        shadowBg.alpha = 0.7
        shadowBg.corner(radius: 5)
        shadowBg.csCenter()
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=20-[v1]->=20-|", options: [], metrics: nil, views: ["v1":shadowBg]))
        
        let toastLabel = UILabel().wTextColor(.white).wFont(pfr(18)).wText(toast)
        shadowBg.addSubview(toastLabel)
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byCharWrapping
        toastLabel.csFullfill(top: 10, left: 10, bottom: -10, right: -10)
        
        let walltime = DispatchWallTime.now() + duration
        DispatchQueue.main.asyncAfter(wallDeadline: walltime) {
            UIView.animate(withDuration: 0.5, animations: {
                containView.alpha = 0
            }) { (finish) in
                containView.removeFromSuperview()
            }
        }
    }
}
public func showLoading(fromView: UIView){
    showLoading(loadingText: skDefaultLoadingText, fromView: fromView)
}
public func showLoading(loadingText: String){
    showLoading(loadingText: loadingText, fromView: nil)
}
public func showLoading(loadingText:String!=skDefaultLoadingText,fromView: UIView?=nil){
    guard let fromView = fromView ?? UIApplication.shared.keyWindow else {
        print("cannot make loading for there is no fatherView or window")
        return
    }
    
    DispatchQueue.main.async {
        //防止重复添加
        if let existLoadingView = fromView.viewWithTag(tagForLoadingView) {
            existLoadingView.removeFromSuperview()
        }
        
        let containView = UIView()
        containView.tag = tagForLoadingView
        fromView.addSubview(containView)
        containView.csFullfill()
        
        let shadowBg = UIView()
        containView.addSubview(shadowBg)
        shadowBg.backgroundColor = .black
        shadowBg.alpha = 0.7
        shadowBg.corner(radius: 11)
        shadowBg.csCenter()
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=20-[v1]->=20-|", options: [], metrics: nil, views: ["v1":shadowBg]))
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        shadowBg.addSubview(indicator)
        indicator.startAnimating()
        indicator.color = .white
        indicator.csTop(20).csCenterX().csWidthHeight(37)
        
        let loadingLabel = UILabel().wTextColor(.white).wFont(pfr(18)).wText(loadingText)
        shadowBg.addSubview(loadingLabel)
        loadingLabel.numberOfLines = 0
        loadingLabel.lineBreakMode = .byCharWrapping
        loadingLabel.csCenterX().cstoBottomOf(view: indicator,constant: 10).csBottom(-20).csLeftRight(constant: 20)
    }
}

public func hideLoading(from: UIView? = nil){
    DispatchQueue.main.async {
        if let _ = from {
            if let existLoadingView = from!.viewWithTag(tagForLoadingView) {
                existLoadingView.removeFromSuperview()
                return
            }
        }
        guard let fromView = UIApplication.shared.keyWindow else {
            print("cannot find keywindow nothing to hide")
            return
        }
        if let existLoadingView = fromView.viewWithTag(tagForLoadingView) {
            existLoadingView.removeFromSuperview()
        }
    }
}
