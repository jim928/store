//
//  UIView.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation

// MARK: - 快捷创建 属性 添加
public extension UIView {
    
    @discardableResult func wBgColor(_ color:UIColor?) -> Self{
        self.backgroundColor = color
        return self
    }
    @discardableResult func wFrame(_ frame:CGRect) -> Self{
        self.frame = frame
        return self
    }
    @discardableResult func wAlpha(_ alpha:CGFloat) -> Self{
        self.alpha = alpha
        return self
    }
    @discardableResult func wTag(_ tag:Int) -> Self{
        self.tag = tag
        return self
    }

    @discardableResult func addTo(_ fatherView:UIView) -> Self{
        fatherView.addSubview(self)
        return self
    }
}

// MARK: - 移除所有 subviews
public extension UIView{
    func removeAllSubviews(){
        subviews.forEach({ $0.removeFromSuperview() })
    }
}


// MARK: - 获取first responder
public extension UIView {
    /// 获取first responder
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }
}


// MARK: - 圆角 带颜色的边
public extension UIView{
    
    /// 设置圆角
    @discardableResult func corner(radius:CGFloat) -> Self{
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        return self
    }
    
    /// 设置边
    @discardableResult func border(width:CGFloat,color:UIColor) -> Self{
        self.layer.masksToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        return self
    }
    
    /// 设置圆角和阴影 make sure the view's backgroundColor is not clear color, then this method will work.
    @discardableResult func corner(radius:CGFloat,shadowColor:UIColor,shadowOffset:CGSize,shadowOpacity:Float,shadowRadius:CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.shadowColor = shadowColor.cgColor;
        layer.shadowOffset = shadowOffset //(0,0)时是四周都有阴影
        layer.shadowOpacity = shadowOpacity;
        layer.shadowRadius = shadowRadius;
        return self
    }
        
    /// 添加阴影,make sure the view's backgroundColor is not clear color, then this method will work.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    func addShadow(ofColor color: UIColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 0.5), radius: CGFloat = 5, offset: CGSize = CGSize(width: 2, height: 2), opacity: Float = 0.3) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

// MARK: - 设置部分或全部圆角
public extension UIView{
    /// 部分或全部圆角，在设置约束之后调用即可生效
    ///
    /// - Parameters:
    ///   - radius: radius for selected corners.
    ///   - corners: array of corners to change (example: .bottomLeft, .topRight).
    @discardableResult func corner(radius: CGFloat,corners: UIRectCorner...) -> Self{
        self.layoutIfNeeded() //这句使得本方法适用于约束
        
        var corner:UIRectCorner = []
        for v in corners {
            corner.insert(UIRectCorner.Element(rawValue: v.rawValue))
        }
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corner,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        return self
    }
}

// MARK: - 找到view所在的vc
public extension UIView {
    
    /// 找到view所在的vc
    var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - 截屏图片
public extension UIView {
    
    /// 截屏图片
    var snapShot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - gradient渐变
public extension UIView {
    
    func addGradient(startColor: UIColor,endColor: UIColor,startPoint:CGPoint,endPoint:CGPoint) {
        guard let superView = self.superview else {
            print("no superview , addGradient() faild")
            return
        }
        let gView = UIGradientView()
        superView.insertSubview(gView, belowSubview: self)
        gView.csFullFillTo(view: self)
        gView.layer.masksToBounds = self.layer.masksToBounds;
        gView.layer.cornerRadius = self.layer.cornerRadius;
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
        gradientLayer.locations = [0,1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = gView.bounds;
        gView.layer.addSublayer(gradientLayer)
        gView.gradientLayer = gradientLayer;
    }
    /// 添加渐变
    func addGradient(startColor: UIColor,endColor: UIColor,isVertical:Bool) {
        if isVertical {
            addGradient(startColor: startColor, endColor: endColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
        }else{
            addGradient(startColor: startColor, endColor: endColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
        }
    }
}
open class UIGradientView: UIView {
    var gradientLayer:CAGradientLayer!
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
}

// MARK: - 获取 创建 指定tag的子view
public extension UIView {
    typealias tagViewClosure = ()->UIView
    
    /// 返回指定tag的子view
    ///
    /// - Parameters:
    ///   - tag: tag of the subView
    ///   - creatClosure: if the sbuView with tag not exist,create in this closure and add to self,dont forget to set the right tag in the closure
    /// - Returns: the view with the tag
    func viewWithTag(tag:Int,creatClosure:tagViewClosure) -> UIView {
        return self.viewWithTag(tag) ?? creatClosure()
    }
}

// MARK: - divide
public extension UIView {
    
    /// divide the view  horizontally equally with several subviews
    /// - Parameters:
    ///   - num: number of subviews
    ///   - viewEnum: closure to config the subview
    /// - Returns: self
    func divideHorizontal(num:Int,viewEnum:((_ subView:UIView,_ index:Int)->())){
        guard num > 0 else {
            return
        }
        
        for i in 0...num-1 {
            let view = UIView().addTo(self).csFullfillVertical().csHorizonSeparate(num: CGFloat(num), index: Int(i))
            viewEnum(view,i)
        }
    }
    /// divide the view  vertically equally with several subviews
    /// - Parameters:
    ///   - num: number of subviews
    ///   - viewEnum: closure to config the subview
    /// - Returns: self
    func divideVertical(num:Int,viewEnum:((_ subView:UIView,_ index:Int)->())){
        guard num > 0 else {
            return
        }
        
        for i in 0...num-1 {
            let view = UIView().addTo(self).csFullfillHorizontal().csVerticalSeparate(num: CGFloat(num), index: Int(i))
            viewEnum(view,i)
        }
    }
}

// MARK: - repeatAdd
public extension UIView {
    private struct SKAddViewProperties{
        static var lastSKAddView:UIView? = nil
    }
    
    var lastSKAddView:UIView?{
        get {
            return objc_getAssociatedObject(self, &SKAddViewProperties.lastSKAddView) as? UIView
        }
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &SKAddViewProperties.lastSKAddView, unwrappedValue as UIView?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    
    /// 横向填充一个view，宽度由内部决定，或在block中配置
    @discardableResult func addSubviewHorizontal(viewConfig:((_ subView:UIView)->())) -> UIView? {
        let view = UIView()
        if let lastV = self.lastSKAddView {
            view.addTo(self).cstoRightOf(view: lastV).csFullfillVertical().csRightLessThanOrEqual()
        }else{
            view.addTo(self).csLeft().csFullfillVertical().csRightLessThanOrEqual()
        }
        viewConfig(view)
        self.lastSKAddView = view
        return view
    }
    
    /// 纵向填充一个view，高度由内部决定，或在block中配置
    @discardableResult func addSubviewVertical(viewConfig:((_ subView:UIView)->())) -> UIView? {
        let view = UIView()
        if let lastV = self.lastSKAddView {
            view.addTo(self).cstoBottomOf(view: lastV).csFullfillHorizontal().csBottomLessThanOrEqual()
        }else{
            view.addTo(self).csTop().csFullfillHorizontal().csBottomLessThanOrEqual()
        }
        viewConfig(view)
        self.lastSKAddView = view
        return view
    }
    
    /// 横向填充一个view
    @discardableResult func addSubviewHorizontalSpace(width:CGFloat) -> UIView? {
        let view = UIView()
        if let lastV = self.lastSKAddView {
            view.addTo(self).cstoRightOf(view: lastV).csWidth(width).csFullfillVertical().csRightLessThanOrEqual()
        }else{
            view.addTo(self).csLeft().csWidth(width).csFullfillVertical().csRightLessThanOrEqual()
        }
        self.lastSKAddView = view
        return view
    }
    
    /// 纵向填充一个view
    @discardableResult func addSubviewVerticalSpace(height:CGFloat) -> UIView? {
        let view = UIView()
        if let lastV = self.lastSKAddView {
            view.addTo(self).cstoBottomOf(view: lastV).csHeight(height).csFullfillHorizontal().csBottomLessThanOrEqual()
        }else{
            view.addTo(self).csTop().csHeight(height).csFullfillHorizontal().csBottomLessThanOrEqual()
        }
        self.lastSKAddView = view
        return view
    }
    
    /// 横向填充多个view，宽度由内部决定，或在block中配置
    @discardableResult func addSubViewHorizontalRepeat(num:UInt,viewConfig:(_ subView:UIView,_ index:UInt)->()) -> UIView?{
        for i in 0..<num {
            addSubviewHorizontal { (v) in
                viewConfig(v,i)
            }
        }
        return self.lastSKAddView
    }
    
    /// 纵向填充多个view，高度由内部决定，或在block中配置
    @discardableResult func addSubViewVerticalRepeat(num:UInt,viewConfig:(_ subView:UIView,_ index:UInt)->()) -> UIView?{
        for i in 0..<num {
            addSubviewVertical(viewConfig: { (v) in
                viewConfig(v,i)
            })
        }
        return self.lastSKAddView
    }
}

// MARK: - addline
public enum SKViewEdge {
    case top,left,bottom,right
}

public extension UIView {
    /** 添加边线
     
     view.addLine(edges: .right,.top,.bottom, color: .lightGray, value: 0.5)
     */
    @discardableResult func addLine(edges:SKViewEdge...,color:UIColor,value:Float) -> Self{
        for edge in edges {
            let line = UIView().wBgColor(color).addTo(self)
            
            switch edge {
            case .top:
                line.csTop().csFullfillHorizontal().csHeight(value.cgfloat)
            case .left:
                line.csLeft().csFullfillVertical().csWidth(value.cgfloat)
            case .bottom:
                line.csBottom().csFullfillHorizontal().csHeight(value.cgfloat)
            case .right:
                line.csRight().csFullfillVertical().csWidth(value.cgfloat)
            }            
        }
        
        return self
    }
}
