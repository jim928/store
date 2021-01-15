//
//  Ex+UITabbar.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/22.
//

import Foundation

/*
self.window = UIWindow(frame: UIScreen.main.bounds)
let tabbarController = UITabBarController()
let vc1 = UIViewController()
let vc2 = UIViewController()
let vc3 = UIViewController()
vc1.tabBarItem = UITabBarItem(title: "首页", image: "msg_white".toImage(), tag: 0)
vc2.tabBarItem = UITabBarItem(title: "出纳", image: "msg_white".toImage(), tag: 1)
vc3.tabBarItem = UITabBarItem(title: "我的", image: "msg_white".toImage(), tag: 2)
vc1.tabBarItem.badgeValue = "8"
self.window?.rootViewController = tabbarController
self.window?.makeKeyAndVisible()
tabbarController.setViewControllers([vc1,vc2,vc3], animated: true)

vc1.tabBarItem = UITabBarItem(title: "首页", image: "tab-home".toImage()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-home-hl".toImage()?.withRenderingMode(.alwaysOriginal))
vc2.tabBarItem = UITabBarItem(title: "我的", image: "tab-mine".toImage()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-mine-hl".toImage()?.withRenderingMode(.alwaysOriginal))

在 iOS 10 之前如果将 tabBar 上面的黑线去掉，可执行下面代码：
[self.tabBar setShadowImage:[UIImage new]];
但在 iOS 10 以后，上面两行代码无效，可执行：
if let v = self.tabBarController?.tabBar.subviews.first?.subviews[0] {
    v.isHidden = true
}
但该代码要写在 UITabBarController 的 子控制器 中，不然不会起作用，或者会使代码崩溃。

tabbar的背景颜色是 UIVisualEffectView
if let v = self.tabBarController?.tabBar.subviews.first?.subviews[1] {
    
}

tabbar 的背景 设置圆角和阴影
if let v = self.tabBarController?.tabBar.subviews.first?.subviews[1] {
    v.corner(radius: 20, shadowColor: .black, shadowOffset: CGSize.init(width: 0, height: 10), shadowOpacity: 0.5, shadowRadius: 10)
    v.subviews.forEach { (sv) in
        sv.layer.cornerRadius = 20
    }
}

设置背景颜色
tabbarController.tabBar.barTintColor = .black


设置高亮和普通的字体和颜色
vc1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.text9AA4C2,NSAttributedString.Key.font:UIFont.pfr(10)], for: UIControl.State.normal)
vc1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.textGold,NSAttributedString.Key.font:UIFont.pfr(10)], for: UIControl.State.selected)

vc2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.text9AA4C2,NSAttributedString.Key.font:UIFont.pfr(10)], for: UIControl.State.normal)
vc2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.textGold,NSAttributedString.Key.font:UIFont.pfr(10)], for: UIControl.State.selected)
*/
