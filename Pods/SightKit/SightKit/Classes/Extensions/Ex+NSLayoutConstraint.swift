//
//  NSLayoutConstraint.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/20.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

extension NSLayoutConstraint.Attribute {
    static var center = NSLayoutConstraint.Attribute(rawValue: 2020)
}

public typealias SKFormationDirection = UICollectionView.ScrollDirection

#if os(iOS)

extension UIView {
    private struct CustomLayoutProperties{
        static var lastCS:NSLayoutConstraint? = nil
    }
    
    /// the last constraint added
    public var lastCS:NSLayoutConstraint?{
        get {
            return objc_getAssociatedObject(self, &CustomLayoutProperties.lastCS) as? NSLayoutConstraint
        }
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &CustomLayoutProperties.lastCS, unwrappedValue as NSLayoutConstraint?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension UIView {
    @discardableResult fileprivate func baseCsTo(attr:NSLayoutConstraint.Attribute,v:UIView? = nil,attrV:NSLayoutConstraint.Attribute? = nil,relatedBy:NSLayoutConstraint.Relation = .equal,multi:CGFloat = 1.0,constant:CGFloat = 0) -> Self{
        guard let toView = v ?? self.superview else {
            print("no another view or superView,cannot make cs for " + Self.className)
            return self
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if attr == .center {
            return self
        }else{
            let cs = NSLayoutConstraint.init(item: self, attribute: attr, relatedBy: relatedBy, toItem: toView, attribute: (attrV != nil) ? attrV! : attr, multiplier: multi, constant: constant)
            cs.isActive = true
            
            self.lastCS = cs
        }
        return self
    }
    
    @discardableResult func csLeft(_ v:UIView,value:CGFloat,multi:CGFloat) -> Self{
        return baseCsTo(attr: .left, v: v, attrV: nil, relatedBy: .equal, multi: multi, constant: value)
    }
    @discardableResult func csLeft(_ v:UIView,value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .left, v: v, attrV: nil, relatedBy: .equal, multi: 1.0, constant: value)
    }
    @discardableResult func csLeft(_ value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .left,constant: value)
    }

    @discardableResult func csRight(_ v:UIView,value:CGFloat,multi:CGFloat) -> Self{
        return baseCsTo(attr: .right, v: v, attrV: nil, relatedBy: .equal, multi: multi, constant: value)
    }
    @discardableResult func csRight(_ v:UIView,value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .right, v: v, attrV: nil, relatedBy: .equal, multi: 1.0, constant: value)
    }
    @discardableResult func csRight(_ value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .right,constant: value)
    }
    
    @discardableResult func csTop(_ v:UIView,value:CGFloat,multi:CGFloat) -> Self{
        return baseCsTo(attr: .top, v: v, attrV: nil, relatedBy: .equal, multi: multi, constant: value)
    }
    @discardableResult func csTop(_ v:UIView,value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .top, v: v, attrV: nil, relatedBy: .equal, multi: 1.0, constant: value)
    }
    @discardableResult func csTop(_ value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .top,constant: value)
    }
    
    @discardableResult func csBottom(_ v:UIView,value:CGFloat,multi:CGFloat) -> Self{
        return baseCsTo(attr: .bottom, v: v, attrV: nil, relatedBy: .equal, multi: multi, constant: value)
    }
    @discardableResult func csBottom(_ v:UIView,value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .bottom, v: v, attrV: nil, relatedBy: .equal, multi: 1.0, constant: value)
    }
    @discardableResult func csBottom(_ value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .bottom,constant: value)
    }

    @discardableResult func csCenterX(_ v:UIView,value:CGFloat,multi:CGFloat) -> Self{
        return baseCsTo(attr: .centerX, v: v, attrV: nil, relatedBy: .equal, multi: multi, constant: value)
    }
    @discardableResult func csCenterX(_ v:UIView,value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .centerX, v: v, attrV: nil, relatedBy: .equal, multi: 1.0, constant: value)
    }
    @discardableResult func csCenterX(_ value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .centerX,constant: value)
    }
    
    @discardableResult func csCenterY(_ v:UIView,value:CGFloat,multi:CGFloat) -> Self{
        return baseCsTo(attr: .centerY, v: v, attrV: nil, relatedBy: .equal, multi: multi, constant: value)
    }
    @discardableResult func csCenterY(_ v:UIView,value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .centerY, v: v, attrV: nil, relatedBy: .equal, multi: 1.0, constant: value)
    }
    @discardableResult func csCenterY(_ value:CGFloat = 0) -> Self{
        return baseCsTo(attr: .centerY,constant: value)
    }

    @discardableResult func csCenter(_ v:UIView? = nil) -> Self{
        baseCsTo(attr: .centerX, v: v)
        baseCsTo(attr: .centerY, v: v)
        return self
    }
    
    @discardableResult func csWidth(_ v:UIView) -> Self{
        return baseCsTo(attr: .width, v: v)
    }
    @discardableResult func csWidth(_ value:CGFloat) -> Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    @discardableResult func csHeight(_ v:UIView) -> Self{
        return baseCsTo(attr: .height, v: v)
    }
    @discardableResult func csHeight(_ value:CGFloat) -> Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    @discardableResult func csWidthHeight(_ value:CGFloat) -> Self{
        self.csWidth(value).csHeight(value)
        return self
    }
    /// 按宽高比设定宽度
    @discardableResult func csWidth_W_H_Rate(_ value:CGFloat) -> Self{
        guard value > 0 else {
            return self
        }
        let cs = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: value, constant: 0)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    /// 按宽高比设定高度
    @discardableResult func csHeight_W_H_Rate(_ value:CGFloat) -> Self{
        guard value > 0 else {
            return self
        }
        let cs = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0/value, constant: 0)
        cs.isActive = true
        self.lastCS = cs
        return self
    }

    
    /// put view on top of given view
    @discardableResult func cstoTopOf(view:UIView,constant:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .bottom, v: view, attrV: .top, constant: constant)
        return self;
    }

    /// put view on bottom of given view
    @discardableResult func cstoBottomOf(view:UIView,constant:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .top, v: view, attrV: .bottom, constant: constant)
        return self;
    }
    
    /// put view on right of given view
    @discardableResult func cstoRightOf(view:UIView,constant:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .left, v: view, attrV: .right, constant: constant)
        return self;
    }

    /// put view on left of given view
    @discardableResult func cstoLeftOf(view:UIView,constant:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .right, v: view, attrV: .left, constant: constant)
        return self;
    }
    
    /// set space of left and right to given view  or superView
    @discardableResult func csLeftRight(view:UIView? = nil,constant:CGFloat) -> Self{
        self.baseCsTo(attr: .left, v: view ?? self.superview, constant: constant)
        self.baseCsTo(attr: .right, v: view ?? self.superview,  constant: -constant)
        return self;
    }
    
    /// 用约束填满父视图
    ///
    /// - Parameter edge: 可选的设置边距
    @discardableResult func csFullfill(top:CGFloat = 0,left:CGFloat = 0,bottom:CGFloat = 0,right:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self}
        
        self.baseCsTo(attr: .top, v: toView, constant: top)
        self.baseCsTo(attr: .left, v: toView, constant: left)
        self.baseCsTo(attr: .bottom, v: toView, constant: bottom)
        self.baseCsTo(attr: .right, v: toView, constant: right)
        
        return self
    }
    
    @discardableResult func csFullfillHorizontal(v:UIView? = nil) -> Self{
        guard let toView = v ?? self.superview else { return self}
        self.csTo(attrs: .left,.right, v: toView)
        return self
    }
    @discardableResult func csFullfillVertical(v:UIView? = nil) -> Self{
        guard let toView = v ?? self.superview else { return self}
        self.csTo(attrs: .top,.bottom, v: toView)
        return self
    }
    @discardableResult func csFullFillTo(view:UIView) -> Self{
        self.baseCsTo(attr: .top, v: view, constant: 0)
        self.baseCsTo(attr: .left, v: view, constant: 0)
        self.baseCsTo(attr: .bottom, v: view, constant: 0)
        self.baseCsTo(attr: .right, v: view, constant: 0)
        return self
    }
    
    @discardableResult func csTo(attrs:NSLayoutConstraint.Attribute...,v:UIView? = nil) -> Self{
        guard let toView = v ?? self.superview else { return self}
        
        for att in attrs {
            self.baseCsTo(attr: att, v: toView, constant: 0)
        }
        return self
    }
    
    // MARK: - greaterThanOrEqual
    @discardableResult func csHeightGreaterThanOrEqual(_ value:CGFloat) -> Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant:value)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    @discardableResult func csWidthGreaterThanOrEqual(_ value:CGFloat) -> Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    @discardableResult func csTopGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .top, v: nil, attrV: nil, relatedBy: .greaterThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csLeftGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .left, v: nil, attrV: nil, relatedBy: .greaterThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csBottomGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .bottom, v: nil, attrV: nil, relatedBy: .greaterThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csRightGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .right, v: nil, attrV: nil, relatedBy: .greaterThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csCenterXGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .centerX, v: nil, attrV: nil, relatedBy: .greaterThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csCenterYGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .centerY, v: nil, attrV: nil, relatedBy: .greaterThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    
    // MARK: - lessThanOrEqual
    @discardableResult func csHeightLessThanOrEqual(_ value:CGFloat) -> Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant:value)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    @discardableResult func csWidthLessThanOrEqual(_ value:CGFloat) -> Self{
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        cs.isActive = true
        self.lastCS = cs
        return self
    }
    @discardableResult func csTopLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .top, v: nil, attrV: nil, relatedBy: .lessThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csLeftLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .left, v: nil, attrV: nil, relatedBy: .lessThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csBottomLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .bottom, v: nil, attrV: nil, relatedBy: .lessThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csRightLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .right, v: nil, attrV: nil, relatedBy: .lessThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csCenterXLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .centerX, v: nil, attrV: nil, relatedBy: .lessThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    @discardableResult func csCenterYLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        self.baseCsTo(attr: .centerY, v: nil, attrV: nil, relatedBy: .lessThanOrEqual, multi: 1.0, constant: value)
        return self
    }
    
    // MARK: - 在父视图 均分放置
    
    /// 水平均分 放置某个子view
    /// - Parameter num: 均分数量
    /// - Parameter index: 第几个view，从0开始，请填入整数
    @discardableResult func csHorizonSeparate(num:CGFloat,index:Int) -> Self{
        let floatIndex = CGFloat(index)
        guard floatIndex < num else {
            print("index out of range ,cannot set horizonSeperate")
            return self
        }
        self.baseCsTo(attr: .width, v: nil, attrV: .width, relatedBy: .equal, multi: 1/num, constant: 0)
        self.baseCsTo(attr: .centerX, v: nil, attrV: .centerX, relatedBy: .equal, multi: (1+floatIndex*2)/num, constant: 0)
        return self
    }
    /// 垂直均分 放置某个子view
    /// - Parameter num: 均分数量
    /// - Parameter index: 第几个view，从0开始， 请填入整数
    @discardableResult func csVerticalSeparate(num:CGFloat,index:Int) -> Self{
        let floatIndex = CGFloat(index)
        guard floatIndex < num else {
            print("index out of range ,cannot set verticalSeperate")
            return self
        }
        self.baseCsTo(attr: .height, v: nil, attrV: .height, relatedBy: .equal, multi: 1/num, constant: 0)
        self.baseCsTo(attr: .centerY, v: nil, attrV: .centerY, relatedBy: .equal, multi: (1+floatIndex*2)/num, constant: 0)
        return self
    }
    
    /// 放置阵列单元
    /// - Parameters:
    ///   - index: 第几个
    ///   - rowNum: 每行几个
    ///   - direction: 纵向还是横向
    ///   - widthHeight: 单元高度（纵向），宽度（横向）
    ///   - horizonSpace: 单元间纵向间距
    ///   - verticalSpace: 单元间横向间距
    ///   - top: 上边距，正值
    ///   - left: 左边距，正值
    ///   - bottom: 下边距，正值
    ///   - right: 右边距，正值
    /// - Returns: self
    @discardableResult func csFormation(index:Int,rowNum:Int,direction:SKFormationDirection,widthHeight:CGFloat,horizonSpace:CGFloat,verticalSpace:CGFloat,top:CGFloat,left:CGFloat,bottom:CGFloat,right:CGFloat) -> Self{
        guard index >= 0 else {
            print("index is valid for formation")
            return self
        }
        guard rowNum > 0 else {
            print("rowNum is 0 , no formation can be build")
            return self
        }
        guard let sView = self.superview else {
            print("no superview, no formation can be build")
            return self
        }
                
        if direction == .horizontal {
            csLeft(left+CGFloat(index/rowNum)*(widthHeight+horizonSpace))
            csWidth(widthHeight)
            csRightLessThanOrEqual(-right)
            
            var lastView:UIView?
            for i in 0..<rowNum {
                let isMe = index % rowNum == i
                let v = isMe ? self : UIView().addTo(sView)
                v.isHidden = !isMe
                if let lastView = lastView {
                    v.cstoBottomOf(view: lastView, constant: verticalSpace).csHeight(lastView)
                }else{
                    v.csTop(top)
                }
                if i == rowNum - 1 {
                    v.csBottom(-bottom)
                }
                
                lastView = v
            }
        }else{
            csTop(top+CGFloat(index/rowNum)*(widthHeight+verticalSpace))
            csHeight(widthHeight)
            csBottomLessThanOrEqual(-bottom)
            
            var lastView:UIView?
            for i in 0..<rowNum {
                let isMe = index % rowNum == i
                let v = isMe ? self : UIView().addTo(sView)
                v.isHidden = !isMe
                if let lastView = lastView {
                    v.cstoRightOf(view: lastView, constant: horizonSpace).csWidth(lastView)
                }else{
                    v.csLeft(left)
                }
                if i == rowNum - 1 {
                    v.csRight(-right)
                }
                
                lastView = v
            }
        }
        
        return self
    }
    
    // MARK: - SafeArea 相关
    @discardableResult func csSafeAreaTop(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.topAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.topAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csTop(value)
        }
        return self
    }
     @discardableResult func csSafeAreaLeft(_ value:CGFloat = 0) -> Self{
         guard let toView = self.superview else { return self }
         if #available(iOS 11.0, *) {
            let cs = self.leftAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.leftAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
         } else {
             csLeft(value)
         }
         return self
     }
    @discardableResult func csSafeAreaBottom(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.bottomAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.bottomAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csBottom(value)
        }
        return self
    }
    @discardableResult func csSafeAreaRight(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.rightAnchor.constraint(equalTo: toView.safeAreaLayoutGuide.rightAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csRight(value)
        }
        return self
    }
    
    @discardableResult func csSafeAreaFullfillHorizontal() -> Self{
        return csSafeAreaLeft().csSafeAreaRight()
    }
    @discardableResult func csSafeAreaFullfillVertical() -> Self{
        return csSafeAreaTop().csSafeAreaBottom()
    }
    @discardableResult func csSafeAreaFullFill() -> Self{
        return csSafeAreaFullfillHorizontal().csSafeAreaFullfillVertical()
    }
    
    
    @discardableResult func csSafeAreaTopGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.topAnchor.constraint(greaterThanOrEqualTo: toView.safeAreaLayoutGuide.topAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csTopGreaterThanOrEqual(value)
        }
        return self
    }
    @discardableResult func csSafeAreaLeftGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.leftAnchor.constraint(greaterThanOrEqualTo: toView.safeAreaLayoutGuide.leftAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csLeftGreaterThanOrEqual(value)
        }
        return self
    }
    @discardableResult func csSafeAreaBottomGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.bottomAnchor.constraint(greaterThanOrEqualTo: toView.safeAreaLayoutGuide.bottomAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csBottomGreaterThanOrEqual(value)
        }
        return self
    }
    @discardableResult func csSafeAreaRightGreaterThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.rightAnchor.constraint(greaterThanOrEqualTo: toView.safeAreaLayoutGuide.rightAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csRightGreaterThanOrEqual(value)
        }
        return self
    }

    @discardableResult func csSafeAreaTopLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.topAnchor.constraint(lessThanOrEqualTo: toView.safeAreaLayoutGuide.topAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csTopLessThanOrEqual(value)
        }
        return self
    }
     @discardableResult func csSafeAreaLeftLessThanOrEqual(_ value:CGFloat = 0) -> Self{
         guard let toView = self.superview else { return self }
         if #available(iOS 11.0, *) {
            let cs = self.leftAnchor.constraint(lessThanOrEqualTo: toView.safeAreaLayoutGuide.leftAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
         } else {
            csLeftLessThanOrEqual(value)
         }
         return self
     }
    @discardableResult func csSafeAreaBottomLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.bottomAnchor.constraint(lessThanOrEqualTo: toView.safeAreaLayoutGuide.bottomAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csBottomLessThanOrEqual(value)
        }
        return self
    }
    @discardableResult func csSafeAreaRightLessThanOrEqual(_ value:CGFloat = 0) -> Self{
        guard let toView = self.superview else { return self }
        if #available(iOS 11.0, *) {
            let cs = self.rightAnchor.constraint(lessThanOrEqualTo: toView.safeAreaLayoutGuide.rightAnchor, constant: value)
            cs.isActive = true
            self.lastCS = cs
        } else {
            csRightLessThanOrEqual(value)
        }
        return self
    }
}


#endif

