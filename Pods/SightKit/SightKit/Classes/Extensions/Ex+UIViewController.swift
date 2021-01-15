//
//  Ex+UIViewController.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public extension UIView {
    /// 所在的vc 是否是 navvc 的 rootvc
    var isMyvcNavRootVC:Bool {
        if let vc = self.viewController {
            return vc.isNavRootVC;
        }
        return false
    }
}

public extension UIViewController {
    /// 是否是 navvc 的 rootvc
    var isNavRootVC:Bool {
        if self == self.navigationController?.viewControllers.first {
            return true
        }
        return false
    }
    
    func presentFromRight(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissToRight() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
