//
//  Ex+UIApplication.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


//找到最上面的vc ，找到最上面的navvc
//UIApplication.shared.topViewController
public extension UIApplication {
    
    /// 获取最上面的 viewController
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    /// 获取最上面的 navigationViewController
    var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}


public extension UIApplication {
    
    /// 获取最上面的viewcontroller
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
