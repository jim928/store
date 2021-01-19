//
//  AppConfig.swift
//  Store
//
//  Created by jim on 2021/1/17.
//

import Foundation
import SightKit

// MARK: - colors
let mainColor = "27ab83".toColor

// MARK: - urls
#if DEBUG
var hostUrl = "http://47.115.54.215:8085"
#else
var hostUrl = "http://47.115.54.215:8085"
#endif

enum AppUrl : String {
    /// 首页内容页信息展示
    case home_content = "/home/content"
    
    /// 分页获取人气推荐商品
    case home_hotProductList = "/home/hotProductList"

    /// 分页获取新品推荐商品
    case home_newProductList = "/home/newProductList"

    /// 获取首页商品分类
    case home_productCateList = "/home/productCateList/"

    /// 分页获取推荐商品
    case home_recommendProductList = "/home/recommendProductList"
    
    /// 根据分类获取专题
    case home_subjectList = "/home/subjectList"
    
    /// 添加品牌关注
    case member_attention_add = "/member/attention/add"
    
    /// 清空关注列表
    case member_attention_clear = "/member/attention/clear"
    
    /// 取消关注
    case member_attention_delete = "/member/attention/delete"
    
    /// 显示关注品牌详情
    case member_attention_detail = "/member/attention/detail"
    
    /// 显示关注列表
    case member_attention_list = "/member/attention/list"
    
    /// 添加商品收藏
    case member_productCollection_add = "/member/productCollection/add"
    
    /// 清空收藏列表
    case member_productCollection_clear = "/member/productCollection/clear"
    
    /// 删除收藏商品
    case member_productCollection_delete = "/member/productCollection/delete"
    
    /// 显示收藏商品详情
    case member_productCollection_detail = "/member/productCollection/detail"
    
    /// 显示收藏列表
    case member_productCollection_list = "/member/productCollection/list"

    /// 清空除浏览记录
    case member_readHistory_clear = "/member/readHistory/clear"
    
    /// 创建浏览记录
    case member_readHistory_create = "/member/readHistory/create"
    
    /// 删除浏览记录
    case member_readHistory_delete = "/member/readHistory/delete"
    
    /// 分页获取用户浏览记录
    case member_readHistory_list = "/member/readHistory/list"

    /// 添加商品到购物车
    case cart_add = "/cart/add"
    
    /// 清空购物车
    case cart_clear = "/cart/clear"
    
    /// 删除购物车中的某个商品
    case cart_delete = "/cart/delete"
    
    /// 获取购物车中某个商品的规格,用于重选规格
    case cart_getProduct = "/cart/getProduct/"
    
    /// 获取某个会员的购物车列表
    case cart_list = "/cart/list"
    
    /// 获取某个会员的购物车列表,包括促销信息
    case cart_list_promotion = "/cart/list/promotion"

    /// 修改购物车中商品的规格
    case cart_update_attr = "/cart/update/attr"
    
    /// 修改购物车中某个商品的数量
    case cart_update_quantity = "/cart/update/quantity"
    
    /// 取消单个超时订单
    case order_cancelOrder = "/order/cancelOrder"
    
    /// 自动取消超时订单
    case order_cancelTimeOutOrder = "/order/cancelTimeOutOrder"
    
    /// 用户取消订单
    case order_cancelUserOrder = "/order/cancelUserOrder"
    
    /// 用户确认收货
    case order_confirmReceiveOrder = "/order/confirmReceiveOrder"
    
    /// 用户删除订单
    case order_deleteOrder = "/order/deleteOrder"
    
    /// 根据ID获取订单详情
    case order_detail = "/order/detail/"
    
    /// 根据购物车信息生成确认单信息
    case order_generateConfirmOrder = "/order/generateConfirmOrder"
    
    /// 根据购物车信息生成订单
    case order_generateOrder = "/order/generateOrder"
    
    /// 按状态分页获取用户订单列表
    case order_list = "/order/list"
    
    /// 用户支付成功的回调
    case order_paySuccess = "/order/paySuccess"
    
    /// 申请退货
    case returnApply_create = "/returnApply/create"
    
    /// 以树形结构获取所有商品分类
    case product_categoryTreeList = "/product/categoryTreeList"
    
    /// 获取前台商品详情
    case product_detail = "/product/detail/"
    
    /// 综合搜索、筛选、排序
    case product_search = "/product/search"
    
    /// 获取品牌详情
    case brand_detail = "/brand/detail/"
    
    /// 分页获取品牌相关商品
    case brand_productList = "/brand/productList"
    
    /// 分页获取推荐品牌
    case brand_recommendList = "/brand/recommendList"
    
    /// 获取验证码
    case sso_getAuthCode = "/sso/getAuthCode"
    
    /// 获取会员信息
    case sso_info = "/sso/info"
    
    /// 会员登录
    case sso_login = "/sso/login"
    
    /// 刷新token
    case sso_refreshToken = "/sso/refreshToken"
    
    /// 会员注册
    case sso_register = "/sso/register"
    
    /// 修改密码
    case sso_updatePassword = "/sso/updatePassword"
    
    /// 领取指定优惠券
    case member_coupon_add = "/member/coupon/add/"
    
    /// 获取用户优惠券列表
    case member_coupon_list = "/member/coupon/list"
    
    /// 获取登录会员购物车的相关优惠券
    case member_coupon_list_cart = "/member/coupon/list/cart/"
    
    /// 获取当前商品相关优惠券
    case member_coupon_listByProduct = "/member/coupon/listByProduct/"
    
    /// 获取用户优惠券历史列表
    case member_coupon_listHistory = "/member/coupon/listHistory"
    
    /// 获取收货地址详情
    case member_address = "/member/address/"

    /// 添加收货地址
    case member_address_add = "/member/address/add"

    /// 删除收货地址
    case member_address_delete = "/member/address/delete/"
    
    /// 显示所有收货地址
    case member_address_list = "/member/address/list"
    
    ///修改收货地址
    case member_address_update = "/member/address/update/"

    
    var fullUrl:String{
        get {
            return String(format: "%@%@", hostUrl,self.rawValue)
        }
    }
}

// MARK: - other defines
let kappTokenSavedKey = "kappTokenSavedKey"
var appToken : String = {
    let str = UserDefaults.standard.string(forKey: kappTokenSavedKey) ?? ""
    return str
}() {
    didSet{
        UserDefaults.standard.set(appToken, forKey: kappTokenSavedKey)
        UserDefaults.standard.synchronize()
    }
}

let kuserNameSavedKey = "kuserNameSavedKey"
var appUserName : String = {
    let str = UserDefaults.standard.string(forKey: kuserNameSavedKey) ?? ""
    return str
}() {
    didSet{
        UserDefaults.standard.set(appUserName, forKey: kuserNameSavedKey)
        UserDefaults.standard.synchronize()
    }
}

var appUserInfo:UserInfoModel?

extension SKResult {
    var success:Bool {
        if let code = self.json?["code"].intValue , code == 200 {
            return true
        }
        return false
    }
    
    var errorMsg:String {
        if let error = self.error {
            return error.localizedDescription
        }
        return self.json?["message"].stringValue ?? "未知的错误"
    }
}

func loginWith(userName:String,passWord:String,result:@escaping ((SKResult)->Void)){
    SKRq().wUrl(AppUrl.sso_login.fullUrl).wPost().wParamInUrl().wParam(["password":passWord,"username":userName]).resume { (res) in
        hideLoading()
        if res.success {
            let header = res.json?["data"]["tokenHead"].stringValue ?? ""
            let token = res.json?["data"]["token"].stringValue ?? ""
            appToken = header + token
            appUserName = userName
            SKRq.globalHeader = ["Authorization":appToken]
        }
        result(res)
    }
}

func clearData(){
    appToken = ""
    appUserInfo = nil
}

func refreshUserInfo(complete:@escaping (()->Void)){
    SKRq().wUrl(AppUrl.sso_info.fullUrl).resume { (result) in
        if let json = result.json?["data"] {
            if let userModel = json.to(type: UserInfoModel.self){
                appUserInfo = userModel as? UserInfoModel
            }
        }
        complete()
    }
}
