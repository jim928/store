//
//  SKScrollBannerView.swift
//  SightKit
//
//  Created by 湛奇 on 2020/9/22.
//

import Foundation

/*
 SKScrollBannerView.configCellUI = { contentView,imgView in
     imgView.corner(radius: 5).csLeftRight(constant: 14).csFullfillVertical()
 }
 let v = SKScrollBannerView().addTo(self.view).csFullfillHorizontal().csTop().csHeight(widthForRate(nowH: ScreenWidth, w: 144, h: 375))
 v.setImgUrls(urls: ["https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_touching_human_hand_other/1800x1200_cat_touching_human_hand_other.jpg?resize=750px:*","https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_touching_human_hand_other/1800x1200_cat_touching_human_hand_other.jpg?resize=750px:*","https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_touching_human_hand_other/1800x1200_cat_touching_human_hand_other.jpg?resize=750px:*","https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_touching_human_hand_other/1800x1200_cat_touching_human_hand_other.jpg?resize=750px:*","https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_touching_human_hand_other/1800x1200_cat_touching_human_hand_other.jpg?resize=750px:*"], configImg: { (imgView, str, index) in
     imgView.download(from:URL.init(string: str ?? "")!)
 }) { (index, url) in
     print("zlog",#file,#function,#line,index,url)
 }
 */

open class SKScrollBannerView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    /// 用来配置imgview 和 cell.contentView 的属性和他们之间的约束关系
    public static var configCellUI:((UIView,UIImageView)->Void)?
    public static var indicatorBottomOffset:CGFloat = -30

    var urls:[String] = []
    var colView:UICollectionView!
    var configImgClosure:((_ imgView:UIImageView,_ url:String?,_ index:Int)->Void)?
    var tapClosure:((_ index:NSInteger,_ url:String)->Void)?
    
    var willDisplayIndex:NSInteger = 0 //将要去的index
    var currentCollectionViewIndex:NSInteger = 0
    
    var autoScrollTimer:Timer? //自动滚动
    var pageIndicator:UIBannerPageIndicator!
    func buildViews() {
        self.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        colView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        colView.dataSource = self
        colView.delegate = self
        colView.isPagingEnabled = true
        colView.showsHorizontalScrollIndicator = false
        colView.backgroundColor = .white
        colView.register(SKScrollBannerViewCell.self, forCellWithReuseIdentifier: "cell")
        colView.backgroundColor = UIColor.white
        self.addSubview(colView)
        colView.csFullfill()
        
        pageIndicator = UIBannerPageIndicator()
        self.addSubview(pageIndicator)
        pageIndicator.csCenterX().csBottom(SKScrollBannerView.indicatorBottomOffset)
    }
    
    public func setImgUrls(urls:[String]? , configImg:((_ imgView:UIImageView,_ url:String?,_ index:Int)->Void)? ,tapClosure: ((_ index:NSInteger,_ url:String)->Void)? ){
        guard let urls = urls else {
            return
        }
        guard urls.count > 0 else {
            return
        }
        self.urls = urls
        self.configImgClosure = configImg
        self.tapClosure = tapClosure
        
        self.colView.reloadData()
                
        //2个或以上才显示页码显示器
        self.pageIndicator.isHidden = true
        if (self.urls.count>1) {
            self.pageIndicator.isHidden = false
            self.pageIndicator.setPointNum(number: self.urls.count)
            self.pageIndicator.setCurrentIndex(index: 0)
        }
        
        if (self.autoScrollTimer != nil) {
            self.autoScrollTimer?.invalidate()
            self.autoScrollTimer = nil
        }
        
        //2个以上才滚动
        if (self.urls.count>1) {
            autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollAction), userInfo: nil, repeats: true)
            
            let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkPosition), userInfo: nil, repeats: false)
        }
    }
    
    @objc func checkPosition(){
        //如果超出范围了 让它重置到中间去
        if (self.currentCollectionViewIndex<500 || self.currentCollectionViewIndex>1500) {
            repeat {
                self.currentCollectionViewIndex += self.urls.count
            } while (self.currentCollectionViewIndex < 1000)
            colView.scrollToItem(at: IndexPath(item: self.currentCollectionViewIndex, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
        }
    }
    
    @objc func scrollAction(){
        if (colView.isDragging) {
            return
        }
        if (colView.isDecelerating){
            return
        }
        self.currentCollectionViewIndex += 1
        
        colView.scrollToItem(at: IndexPath(item: self.currentCollectionViewIndex, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        pageIndicator.setCurrentIndex(index: self.currentCollectionViewIndex%self.urls.count)
        
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkPosition), userInfo: nil, repeats: false)
    }
    // MARK: - UICollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2000
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        return CGSize(width: width, height: colView.frame.size.height)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SKScrollBannerViewCell
        cell.imgView.image = nil
        
        if self.urls.count > 0 {
            let index = indexPath.item%(self.urls.count)
            let url = self.urls[index]
            self.configImgClosure?(cell.imgView,url,index)
        }
        
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.urls.count > 0 {
            let index = indexPath.item%(self.urls.count)
            let url = self.urls[index]
            self.tapClosure?(index,url)
        }
    }
    // MARK: - 手指拖动相关
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.colView.isDragging {
            self.willDisplayIndex = indexPath.item
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.urls.count == 0 { return }
        self.currentCollectionViewIndex = self.willDisplayIndex
        self.pageIndicator.setCurrentIndex(index: self.currentCollectionViewIndex%self.urls.count)
    }
}

open class SKScrollBannerViewCell:UICollectionViewCell{
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    var imgView:UIImageView!
    func buildViews() {
        imgView = UIImageView()
        self.contentView.addSubview(imgView)
        if let config = SKScrollBannerView.configCellUI {
            config(self.contentView,imgView)
        }else{
            imgView.backgroundColor = .black
            imgView.csFullfill()
        }
    }
}


/// 页码标识
open class UIBannerPageIndicator: UIView {
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    var views:[UIView]! = []
    
    func setPointNum(number:NSInteger){
        guard number > 0 else {
            return
        }
        self.removeAllSubviews()
        var lastV:UIView?
        for i in 0...number-1 {
            let v = UIView()
            v.backgroundColor = .white
            v.corner(radius: 2)
            v.alpha = 0.2
            self.addSubview(v)
            
            v.csTo(attrs: .top,.bottom)
            v.csHeight(4)
            v.csWidth(6)
            if let lastV = lastV{
                v.cstoRightOf(view: lastV, constant: 6)
            }else{
                v.csLeft()
            }
            if i == number-1{
                v.csRight()
            }
            
            self.views.append(v)
            lastV = v
        }
    }
    
    func setCurrentIndex(index:NSInteger){
        guard index < self.views.count else {
            return
        }
        
        for (i,v) in self.views.enumerated() {
            v.alpha = 0.2
            var csWid:NSLayoutConstraint?
            for cs in v.constraints {
                if cs.firstAttribute == .width {
                    csWid = cs
                }
            }
            csWid?.constant = 6
            
            if i == index {
                v.alpha = 1
                csWid?.constant = 16
            }
        }
    }
}

