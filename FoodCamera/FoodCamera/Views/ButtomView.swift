//
//  ButtomView.swift
//  FoodCamera
//
//  Created by soson on 2018/9/11.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit
import SnapKit

enum cameraMode:Int {
    case camera
    case video
}

class ButtomView: UIView {

    //按钮点击闭包
    typealias clickButtomBlock = (NSInteger)->Swift.Void
    var clickButtomBlock: clickButtomBlock?
    
    //ScrollView的按钮点击
    typealias clickScrollViewClickBlock = (NSInteger)->Swift.Void
    var clickScrollViewClickBlock: clickScrollViewClickBlock?
    
    
    //创建scorllView
    let scrollView :UIScrollView = UIScrollView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func initView() {
        
        let setbutton = UIButton()   // 相册
        setbutton.setImage(UIImage(named: "take_btn_album"), for: .normal)
        setbutton.setImage(UIImage(named: "take_btn_album"), for: .selected)
        setbutton.tag = 0
        setbutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.addSubview(setbutton)
        
        setbutton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(45)
            make.bottomMargin.equalTo(-50)
            make.leftMargin.equalTo(30)
        }
        
    
        let sizebutton = UIButton()   // 滤镜
        
        sizebutton.setImage(UIImage(named: "edit_blur_circle"), for: .normal)
        sizebutton.setImage(UIImage(named: "edit_blur_circle"), for: .selected)
        sizebutton.tag = 1
        sizebutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.addSubview(sizebutton)

//        let sizebutton = UIImageView()   // 拍照图片
//        sizebutton.image = UIImage(named: "edit_blur_circle")
//        sizebutton.isUserInteractionEnabled = true
//        // 添加到view上
//        self.addSubview(sizebutton)
        
        
        sizebutton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
//            make.bottomMargin.equalTo(-50)
            make.center.equalToSuperview()

        }

        
        
        let cvbutton = UIButton()   // 滤镜
       
        cvbutton.setImage(UIImage(named: "take_btn_filter"), for: .normal)
        cvbutton.setImage(UIImage(named: "take_btn_filter"), for: .selected)
        cvbutton.tag = 2
        cvbutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.addSubview(cvbutton)
        
        cvbutton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(45)
            make.bottomMargin.equalTo(-50)
            make.rightMargin.equalTo(-45)

        }
        
    }
    
    
    @objc func btnClick(_ btn:UIButton){
        if (self.clickButtomBlock != nil) {
            self.clickButtomBlock!(btn.tag)
        }
    }
}
