//
//  TopView.swift
//  FoodCamera
//
//  Created by soson on 2018/9/9.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit

class TopView: UIView {

    //定义闭包
    typealias clickBtnBlock = (NSInteger)->Swift.Void
    var clickBtnBlock: clickBtnBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
       
        let setbutton = UIButton()   // 定义button
        let setx = 10 * screenPTFactor
        var setrect:CGRect?
        if UIDevice.current.isX() {
            setrect = CGRect(x: setx, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }else if(UIDevice.current.isheight960()){  //适配ipad
            setrect = CGRect(x: setx, y:20 * screenPTFactor , width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }else{
            setrect = CGRect(x: setx, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }
        // 给frame
        setbutton.frame = setrect!
        setbutton.setImage(UIImage(named: "button1"), for: .normal)
        setbutton.setImage(UIImage(named: "button1_sel"), for: .selected)
        setbutton.tag = 0
        setbutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.addSubview(setbutton)
        
        
        let sizebutton = UIButton()   // 定义button
        let sizespace :CGFloat = (screenWidth / 2) - (34 * screenPTFactor / 2)
        let sizex = sizespace
        var sizerect:CGRect?
        if UIDevice.current.isX() {
            sizerect = CGRect(x: sizex, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }else if(UIDevice.current.isheight960()){  //适配ipad
            sizerect = CGRect(x: sizex, y:20 * screenPTFactor , width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }else{
            sizerect = CGRect(x: sizex, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }
        // 给frame
        sizebutton.frame = sizerect!
        sizebutton.setImage(UIImage(named: "button2"), for: .normal)
        sizebutton.setImage(UIImage(named: "button2_sel"), for: .selected)
        sizebutton.tag = 1
        sizebutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.addSubview(sizebutton)
        
        
        
        let cvbutton = UIButton()   // 定义button
        let cvspace :CGFloat = screenWidth - 10 - 34 * screenPTFactor
        let cvx = cvspace
        var cvrect:CGRect?
        if UIDevice.current.isX() {
            cvrect = CGRect(x: cvx, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }else if(UIDevice.current.isheight960()){  //适配ipad
            cvrect = CGRect(x: cvx, y:20 * screenPTFactor , width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }else{
            cvrect = CGRect(x: cvx, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
        }
        // 给frame
        cvbutton.frame = cvrect!
        cvbutton.setImage(UIImage(named: "button3"), for: .normal)
        cvbutton.setImage(UIImage(named: "button3_sel"), for: .selected)
        cvbutton.tag = 2
        cvbutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.addSubview(cvbutton)
        
        
        
//        // 计算空隙 空隙 = (总宽 - 所有button的宽)/空隙个数
////        let gap = CGFloat((self.frame.size.width - (34*CGFloat(3)))/(CGFloat(3+1)))
//        var x :CGFloat = 0.0
//        for i in 0..<3 {
//            let button = UIButton()   // 定义button
//            var rect:CGRect?
//
//
//            switch (i) {
//            case 0:
//                x = 10 * screenPTFactor
//                break;
//            case 1:
//                //减去两边的按钮+空隙
//                let space :CGFloat = (screenWidth - (10 + 34 * screenPTFactor) * 2) / 2
//                x = 10 + 34 + space
//                break;
//            case 2:
//                let space :CGFloat = screenWidth - 10 + 34 * screenPTFactor
//                x = space
//                break;
//            default:
//                break;
//            }
//            if UIDevice.current.isX() {
//                rect = CGRect(x: x, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
//            }else if(UIDevice.current.isheight960()){  //适配ipad
//                rect = CGRect(x: x, y:20 * screenPTFactor , width: 34 * screenPTFactor, height: 34 * screenPTFactor)
//            }else{
//                rect = CGRect(x: x, y: 20 * screenPTFactor, width: 34 * screenPTFactor, height: 34 * screenPTFactor)
//            }
//
//            // 给frame
//            button.frame = rect!
//            button.setImage(UIImage(named: "button\(i)"), for: .normal)
//            button.setImage(UIImage(named: "button\(i)_sel"), for: .selected)
//            button.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
//            // 添加到view上
//            self.addSubview(button)
//
//        }
        
    }
    
    @objc func btnClick(_ btn:UIButton){
        if (self.clickBtnBlock != nil) {
            self.clickBtnBlock!(btn.tag)
        }
    }
    

    
    
    
    
}
