//
//  SKNoticeBar.swift
//  SightKit
//
//  Created by mac on 23/10/2020.
//

import Foundation

/** 跑马灯
 ## 使用示例
 ```
 SKNoticeBar.height = 30
 let noticeBar = SKNoticeBar().addTo(self.view).csCenterY().csFullfillHorizontal().csHeight(30)
 noticeBar.noticesArray = ["SightKit is a fast development kit for iOS,it saves a lot of work time, it is great!","SightKit 是一个快速开发库，可以极大的加快开发速度。"]
 */
public class SKNoticeBar: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// pixs per second to move in horizon
    public static var PPS:CGFloat = 20
    /// make sure its the same value of the height of the NoticeBar
    public static var height:CGFloat = 30
    /// the minimun time long every notice will stay
    public static var minimunStaySeconds:CGFloat = 1.0
    
    var label1:UILabel!
    var label2:UILabel!
    var csLabel1Top:NSLayoutConstraint!
    var csLabel2Top:NSLayoutConstraint!
    var csLabel1Left:NSLayoutConstraint!
    var cslabel2Left:NSLayoutConstraint!
    var currentIndex : Int = 0
    public var noticesArray:[String]? {
        didSet {
            if let count = noticesArray?.count {
                if count == 1 {
                    label1.text = noticesArray![0]
                }
                if count > 1 {
                    currentIndex = 0
                    label1.text = noticesArray![0]
                    label2.text = noticesArray![1]
                    self.layoutIfNeeded()
                    moveHorizon()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    func buildViews() {
        clipsToBounds = true
        
        label1 = UILabel().wTextColor(.black).wFont(pfr12).addTo(self).csHeight(self)
        csLabel1Top = label1.csTop().lastCS
        csLabel1Left = label1.csLeft().lastCS
        
        label2 = UILabel().wTextColor(.black).wFont(pfr12).addTo(self).csLeft().csHeight(self)
        csLabel2Top = label2.csTop(SKNoticeBar.height).lastCS
        cslabel2Left = label2.csLeft().lastCS
    }

    @objc func moveHorizon(){
        let label:UILabel = label1.frame.origin.y==0 ? label1 : label2
        if (label.intrinsicContentSize.width <= self.frame.size.width){
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + TimeInterval(SKNoticeBar.minimunStaySeconds)) {
                self.moveYPosition()
            }
        }else{
            let offset = label.intrinsicContentSize.width-self.frame.size.width
            var timeInterval = offset/SKNoticeBar.PPS
            timeInterval = max(timeInterval, SKNoticeBar.minimunStaySeconds)
            UIView.animate(withDuration: TimeInterval(timeInterval), animations: {
                self.csLabel1Left.constant = -offset
                self.layoutIfNeeded()
            }) { (finish) in
                DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.0) {
                    self.moveYPosition()
                }
            }
        }
    }
    @objc func moveYPosition(){
        UIView.animate(withDuration: 1.0, animations: {
            self.csLabel1Top.constant = -SKNoticeBar.height
            self.csLabel2Top.constant = 0
            self.layoutIfNeeded()
        }) { (finish) in
            self.csLabel1Left.constant = 0
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.0) {
                self.resetPosition()
            }
        }
    }
    @objc func resetPosition(){
        if let count = self.noticesArray?.count {
            currentIndex = currentIndex+1
            if currentIndex >= count { currentIndex = 0 }
            
            var index2 = currentIndex + 1
            if index2 >= count { index2 = 0 }
            label1.text = self.noticesArray![currentIndex]
            label2.text = self.noticesArray![index2]
            
            self.csLabel1Top.constant = 0
            self.csLabel2Top.constant = SKNoticeBar.height
            self.layoutIfNeeded()
            self.moveHorizon()
        }
    }
}
