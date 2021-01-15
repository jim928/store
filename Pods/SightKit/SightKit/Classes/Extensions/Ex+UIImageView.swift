//
//  Ex+UIImageView.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/21.
//

import Foundation


public extension UIImageView {
    func addTapClosure(closure: @escaping UIButtonTargetClosure){
        let btn = UIButton()
        self.isUserInteractionEnabled = true
        self.addSubview(btn)
        btn.csFullfill()
        btn.addTargetClosure { (btn) in
            closure(btn)
        }
    }
}

// MARK: - Methods
public extension UIImageView {
    
    /// SwifterSwift: Set image from a URL.
    ///
    /// - Parameters:
    ///   - url: URL of image.
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    func download(
        from url: URL,
        placeholder: UIImage? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil) {
        
        image = placeholder
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async { [unowned self] in
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }
}

public extension UIView {
    /// 模糊化
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
}


public extension UIImageView {
    /// SwifterSwift: Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
}

public extension UIImageView {
    
    /// 添加点击全屏，再点击移除
    func addTapFullScreen(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapForCallFullScreenImg))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func didTapForCallFullScreenImg(){
        if let window = UIApplication.shared.keyWindow {
            let imgView = UIImageView(image: self.image)
            window.addSubview(imgView)
            imgView.contentMode = .scaleAspectFit
            imgView.backgroundColor = .black
            imgView.csFullfill()
            imgView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: imgView, action: #selector(didTapForDismissFullScreenImg))
            imgView.addGestureRecognizer(tap)
        }
    }
    
    @objc fileprivate func didTapForDismissFullScreenImg(){
        self.removeFromSuperview()
    }
}
