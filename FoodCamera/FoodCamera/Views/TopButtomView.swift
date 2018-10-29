 //
//  TopButtomView.swift
//  FoodCamera
//
//  Created by soson on 2018/9/10.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit


let kButtonWidth:CGFloat = 34
let kButtonHeight:CGFloat = 34
let kButtonMargin:CGFloat = 15


class TopButtomView: UIView {

    //定义闭包
    typealias clickTopButtomBlock = (NSInteger)->Swift.Void
    var clickTopButtomBlock: clickTopButtomBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        // 计算空隙 空隙 = (总宽 - 所有button的宽)/空隙个数
        let gap = CGFloat((self.frame.size.width - (34*CGFloat(5)))/(CGFloat(6)))
        
        let titleArr:Array = ["闪光灯","模糊","延时拍照","网格线","设置"]

        
        for i in 0..<5 {
            
            
            let row:Int  = i / 5;//行
                
//            let x:CGFloat = optionX * (kButtonMargin + kButtonWidth);
            let x = (CGFloat(i) * 60 + 20) * screenPTFactor
          
            let y:CGFloat =  10

            
            let button = UIButton()   // 定义button
            var rect:CGRect?

            

            if UIDevice.current.isX() {
                rect = CGRect(x: x, y:y, width: 60 * screenPTFactor, height: 60 * screenPTFactor)
            }else if(UIDevice.current.isheight960()){  //适配ipad
                rect = CGRect(x: x, y:y , width: 60 * screenPTFactor, height: 60 * screenPTFactor)
            }else{
                rect = CGRect(x: x, y: y, width: 60 * screenPTFactor, height: 60 * screenPTFactor)
            }

            // 给frame
            button.frame = rect!
            button.setImage(UIImage(named: "buttom\(i + 1)"), for: .normal)
            button.setImage(UIImage(named: "buttom\(i + 1)_sel"), for: .selected)
            button.setTitle(titleArr[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
            initButton(button)
            // 添加到view上
            self.addSubview(button)

        }
    }
    
    @objc func btnClick(_ btn:UIButton){
        if (self.clickTopButtomBlock != nil) {
            self.clickTopButtomBlock!(btn.tag)
        }
    }
    

    func initButton(_ btn: UIButton?) {
        btn?.contentHorizontalAlignment = .center //使图片和文字水平居中显示
        btn?.titleEdgeInsets = UIEdgeInsetsMake((btn?.imageView?.frame.size.height)! + 10, -(btn?.imageView?.frame.size.width ?? 0.0) - 10, 0.0, 0.0) //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        btn?.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -(btn?.titleLabel?.bounds.size.width ?? 0.0)) //图片距离右边框距离减少图片的宽度，其它不边
    }
}
