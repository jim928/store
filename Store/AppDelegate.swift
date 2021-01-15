//
//  AppDelegate.swift
//  Store
//
//  Created by jim on 2021/1/16.
//

import UIKit

/*
 1，删除main.storyboard
 2，工程中info.plist 找到ApplicationSceneManifest 一栏   删除
 3，找到SceneDelegate.swift  删除
 4，找到target - General  - Deployment Info -  Main Interface  中的 Main 置空
 5，AppDelegate.Swift 内容修改为
 */
import SightKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tabbarController = UITabBarController()
        let vc1 = HomeVC()
        let vc2 = MenuVC()
        let vc3 = DateBuyVC()
        let vc4 = CartVC()
        let vc5 = MineVC()
        vc1.tabBarItem = UITabBarItem(title: "首页", image: "tab-home".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-home-hl".toImg()?.withRenderingMode(.alwaysOriginal))
        vc2.tabBarItem = UITabBarItem(title: "菜单", image: "tab-menu".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-menu-hl".toImg()?.withRenderingMode(.alwaysOriginal))
        vc3.tabBarItem = UITabBarItem(title: "定期购", image: "tab-buy".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-buy-hl".toImg()?.withRenderingMode(.alwaysOriginal))
        vc4.tabBarItem = UITabBarItem(title: "购物车", image: "tab-cart".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-cart-hl".toImg()?.withRenderingMode(.alwaysOriginal))
        vc5.tabBarItem = UITabBarItem(title: "我的", image: "tab-mine".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-mine-hl".toImg()?.withRenderingMode(.alwaysOriginal))
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
        tabbarController.setViewControllers([BaseNavVC.init(rootViewController: vc1),
                                             BaseNavVC.init(rootViewController: vc2),
                                             BaseNavVC.init(rootViewController: vc3),
                                             BaseNavVC.init(rootViewController: vc4),
                                             BaseNavVC.init(rootViewController: vc5)], animated: true)
        
        tabbarController.tabBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let vcs = [vc1,vc2,vc3,vc4,vc5]
        for v in vcs{
            v.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], for: .normal)
            v.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8235294118, green: 0.5764705882, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], for: .selected)
        }
        
        return true
    }
}

