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
        self.window?.makeKeyAndVisible()
        
        gotoTabbarVC()
        
        return true
    }
}

func gotoTabbarVC(){
    let tabbarController = UITabBarController()
    let vc1 = HomeVC()
    let vc2 = CategoryVC()
    let vc3 = TopicVC()
    let vc4 = MineVC()
    vc1.tabBarItem = UITabBarItem(title: "首页", image: "tab-home".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-home-hl".toImg()?.withRenderingMode(.alwaysOriginal))
    vc2.tabBarItem = UITabBarItem(title: "分类", image: "tab-category".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-category-hl".toImg()?.withRenderingMode(.alwaysOriginal))
    vc3.tabBarItem = UITabBarItem(title: "专题", image: "tab-topic".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-topic-hl".toImg()?.withRenderingMode(.alwaysOriginal))
    vc4.tabBarItem = UITabBarItem(title: "我的", image: "tab-me".toImg()?.withRenderingMode(.alwaysOriginal), selectedImage: "tab-me-hl".toImg()?.withRenderingMode(.alwaysOriginal))
    UIApplication.shared.keyWindow?.rootViewController = tabbarController
    tabbarController.setViewControllers([BaseNavVC.init(rootViewController: vc1),
                                         BaseNavVC.init(rootViewController: vc2),
                                         BaseNavVC.init(rootViewController: vc3),
                                         BaseNavVC.init(rootViewController: vc4)], animated: true)
    
    tabbarController.tabBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    let vcs = [vc1,vc2,vc3,vc4]
    for v in vcs{
        v.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], for: .normal)
        v.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], for: .selected)
    }
    
    let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    tabbarController.delegate = myAppdelegate
}
func gotoLoginVC(){
    let vc = LoginRegisterVC()
    UIApplication.shared.keyWindow?.rootViewController = vc
}

func gotoRegisterVC(){
    let vc = LoginRegisterVC()
    UIApplication.shared.keyWindow?.rootViewController = vc
    vc.showRegisterView()
}

extension AppDelegate : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.index(of: viewController)
        if index == 3 {
            if appToken.count == 0 {
                let alert = UIAlertController.init(title: nil, message: "需要登录", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction.init(title: "去登录", style: .default, handler: { (action) in
                    gotoLoginVC()
                }))
                tabBarController.present(alert, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
}

