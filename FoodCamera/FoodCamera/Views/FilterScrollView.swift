//
//  FilterScrollView.swift
//  FoodCamera
//
//  Created by soson on 2018/9/30.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit

class FilterScrollView: UIView,UIScrollViewDelegate {
    
    //切换闭包
    typealias scrollviewBlock = (NSInteger)->Swift.Void
    var scrollviewBlock: scrollviewBlock?
    
    var numOfPages :Int = 10
    var pageWidth :Int = Int(screenWidth)
    var pageHeight :Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {

        //scrollView的初始化
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        //为了让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width: pageWidth * numOfPages,
        height: pageHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        //添加子页面
        for i in 0..<numOfPages{
            let btn = UIButton()
            btn.setTitle("你好这位朋友", for: .normal)
            btn.setTitleColor(UIColor.yellow, for: .normal)
//            btn.backgroundColor = ColorRandom()
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            btn.frame = CGRect(x:pageWidth * i, y:0,width:Int(self.frame.size.width), height:Int(self.frame.size.height))
            scrollView.addSubview(btn)
        }
        self.addSubview(scrollView)
    
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
       var clickWhich = (Int(scrollView.contentOffset.x) / Int(screenWidth))
        print("click:\(clickWhich)")
        if (self.scrollviewBlock != nil) {
            self.scrollviewBlock!(clickWhich)
        }
        
    }

    
    
    
    
    /**
     *  RGBA颜色
     */
    func ColorRGBA(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
        
        return UIColor(red:r/255.0,green:g/255.0,blue:b/255.0,alpha:a)
    }
    /**
     *  RGB颜色
     */
    func ColorRGB(_ r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
        
        return ColorRGBA(r, g: g, b: b, a: 1.0)
    }
    /**
     *  随机色
     */
    func ColorRandom() -> UIColor {
        
        return ColorRGB(CGFloat(arc4random()%255), g: CGFloat(arc4random()%255), b: CGFloat(arc4random()%255))
    }
    
    
}
