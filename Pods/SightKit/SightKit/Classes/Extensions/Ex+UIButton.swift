//
//  Ex+UIButton.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public extension UIButton {
    /// 快捷初始化 带图片和文字
    convenience init(img:String?,title:String?){
        self.init()
        setImage(img?.toImg(), for: .normal)
        setTitle(title, for: .normal)
    }
    
    @discardableResult func wTitle(_ title:String?) -> UIButton {
        self.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult func wImg(_ imgName:String?) -> UIButton {
        self.setImage(imgName?.toImg(), for: .normal)
        return self
    }
    @discardableResult func wSelectedImg(_ imgName:String?) -> UIButton {
        self.setImage(imgName?.toImg(), for: .selected)
        return self
    }
    @discardableResult func wHighlightedImg(_ imgName:String?) -> UIButton {
        self.setImage(imgName?.toImg(), for: .highlighted)
        return self
    }
    
    @discardableResult func wTitleColor(_ color:UIColor?) -> UIButton {
        self.setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult func wFont(_ font:UIFont?) -> UIButton {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult func wAttributedTitle(_ attributedTitle:NSAttributedString?) -> UIButton {
        self.setAttributedTitle(attributedTitle, for: .normal)
        return self
    }

    
    /// add features(titleColor,font,title,superView,image,attributedTitle)
    /// - UIColor  titleColor for nomal
    /// - UIFont  titlelabel.font
    /// - String  title for normal
    /// - UIView  .addToSuperView
    /// - UIImage  image for normal
    /// - NSAttributedString  NSAttributedString for normal
    /// - Parameter features: UIColor ,UIFont,String,UIView ,UIImage
    @discardableResult func wFeatures(_ features:Any?...) -> UIButton{
        for fea in features {
            if fea is UIColor {
                self.wTitleColor(fea as? UIColor)
            }
            if fea is UIFont {
                self.wFont(fea as? UIFont)
            }
            if fea is String {
                self.wTitle(fea as? String)
            }
            if fea is UIView {
                self.addTo(fea as! UIView)
            }
            if fea is UIImage {
                self.setImage(fea as? UIImage, for: .normal)
            }
            if fea is NSAttributedString {
                self.wAttributedTitle(fea as? NSAttributedString)
            }
        }
        return self
    }
    
    /// create UIButton with features(titleColor,font,title,superView,image,attributedTitle)
    /// - UIColor  titleColor for nomal
    /// - UIFont  titlelabel.font
    /// - String  title for normal
    /// - UIView  .addToSuperView
    /// - UIImage  image for normal
    /// - NSAttributedString  NSAttributedString for normal
    /// - Parameter features: UIColor ,UIFont,String,UIView ,UIImage
    static func wFeatures(_ features:Any?...) -> UIButton{
        let btn = UIButton()
        for fea in features {
            if fea is UIColor {
                btn.wTitleColor(fea as? UIColor)
            }
            if fea is UIFont {
                btn.wFont(fea as? UIFont)
            }
            if fea is String {
                btn.wTitle(fea as? String)
            }
            if fea is UIView {
                btn.addTo(fea as! UIView)
            }
            if fea is UIImage {
                btn.setImage(fea as? UIImage, for: .normal)
            }
        }
        return btn
    }

}

// MARK: - button点击closure
public typealias UIButtonTargetClosure = (UIButton) -> ()
open class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}
public extension UIButton {
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// block方式点击回调
    @discardableResult func addTargetClosure(closure: @escaping UIButtonTargetClosure) -> Self{
        targetClosure = closure
        addTarget(self, action: #selector(closureAction), for: .touchUpInside)
        return self
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}


// MARK: - 设置不同状态下纯色背景
public extension UIButton {
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 设置不同状态背景颜色
    @discardableResult func setBackgroundColor(_ color: UIColor, for state: UIControl.State) -> UIButton{
        self.setBackgroundImage(image(withColor: color), for: state)
        return self
    }
}

// MARK: - 图片和文字位置
public extension UIButton {
    /// label被压缩成省略号的原因是 默认情况下 image在左，titleLabel在右， 给定的button宽度不足就会成省略号
    
    /// **NOTE**: Before invoke this methods you should setup title with font and image already 在使用约束的情况下，如果宽高给的不够 会导致位置错误
    /// inset是相对原来位置的偏移 ， 将它理解为title的新位置与title旧位置之间的相对关系
    @discardableResult func setImgToTop(titleSpace space: CGFloat = 4.0) -> UIButton{
        guard let currentImage = currentImage else { return self }
        guard let currentTitle = currentTitle as NSString? else { return self }
        guard let titleLabel = titleLabel else { return self }
        
        //先放大内容区域 以防止宽高不够导致的label被压缩问题
        contentEdgeInsets = UIEdgeInsets(top: -1000, left: -1000, bottom: -1000, right: -1000)
        
        let halfSpace = (space / 2.0)
        let halfImageWidth = (currentImage.size.width / 2.0)
        let halfImageHeight = (currentImage.size.height / 2.0)
        titleEdgeInsets = UIEdgeInsets(top: halfImageHeight + halfSpace,
                                       left: -halfImageWidth,
                                       bottom: -halfImageHeight - halfSpace,
                                       right: halfImageWidth
        )
        
        let titleBounds = currentTitle.size(withAttributes: [.font: titleLabel.font!])
        let halfEdgeWidth = (titleBounds.width / 2.0)
        let halfEdgeHeight = (titleBounds.height / 2.0)
        imageEdgeInsets = UIEdgeInsets(top: -halfEdgeHeight - halfSpace,
                                       left: halfEdgeWidth,
                                       bottom: halfEdgeHeight + halfSpace,
                                       right: -halfEdgeWidth
        )
        return self
    }
    
    /// **NOTE**: Before invoke this methods you should setup title with font and image already
    @discardableResult func setImgToBottom(titleSpace space: CGFloat = 4.0) -> UIButton{
        guard let currentImage = currentImage else { return self }
        guard let currentTitle = currentTitle as NSString? else { return self }
        guard let titleLabel = titleLabel else { return self }
        
        //先放大内容区域 以防止宽高不够导致的label被压缩问题
        contentEdgeInsets = UIEdgeInsets(top: -1000, left: -1000, bottom: -1000, right: -1000)

        let halfSpace = (space / 2.0)
        let halfImageWidth = (currentImage.size.width / 2.0)
        let halfImageHeight = (currentImage.size.height / 2.0)
        titleEdgeInsets = UIEdgeInsets(top: -halfImageHeight - halfSpace,
                                       left: -halfImageWidth,
                                       bottom: halfImageHeight + halfSpace,
                                       right: halfImageWidth
        )
        
        let titleBounds = currentTitle.size(withAttributes: [.font: titleLabel.font!])
        let halfEdgeWidth = (titleBounds.width / 2.0)
        let halfEdgeHeight = (titleBounds.height / 2.0)
        imageEdgeInsets = UIEdgeInsets(top: halfEdgeHeight + halfSpace,
                                       left: halfEdgeWidth,
                                       bottom: -halfEdgeHeight - halfSpace,
                                       right: -halfEdgeWidth
        )
        return self
    }
    
    /// **NOTE**: Before invoke this methods you should setup title with font and image already
    @discardableResult func setImgToLeft(titleSpace space: CGFloat = 4.0) -> UIButton{
        //先放大内容区域 以防止宽高不够导致的label被压缩问题
        contentEdgeInsets = UIEdgeInsets(top: -1000, left: -1000, bottom: -1000, right: -1000)

        let halfSpace = (space / 2.0)
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: halfSpace,
                                       bottom: 0,
                                       right: -halfSpace
        )
        
        imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -halfSpace,
                                       bottom: 0,
                                       right: halfSpace
        )
        return self
    }
    
    /// **NOTE**: Before invoke this methods you should setup title with font and image already
    @discardableResult func setImgToRight(titleSpace space: CGFloat = 4.0) -> UIButton{
        guard let currentImage = currentImage else { return self }
        guard let currentTitle = currentTitle as NSString? else { return self }
        guard let titleLabel = titleLabel else { return self }
        
        //先放大内容区域 以防止宽高不够导致的label被压缩问题
        contentEdgeInsets = UIEdgeInsets(top: -1000, left: -1000, bottom: -1000, right: -1000)

        let halfSpace = (space / 2.0)
        let imageWidth = currentImage.size.width
        let edgeWidth = currentTitle.size(withAttributes: [.font: titleLabel.font!]).width
        
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -imageWidth - halfSpace,
                                       bottom: 0,
                                       right: imageWidth + halfSpace
        )
        imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: edgeWidth + halfSpace,
                                       bottom: 0,
                                       right: -edgeWidth - halfSpace
        )
        return self
    }
}


