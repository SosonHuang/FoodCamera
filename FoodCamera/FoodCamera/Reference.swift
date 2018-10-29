//
//  File.swift
//  FoodCamera
//
//  Created by soson on 2018/9/5.
//  Copyright © 2018年 soson. All rights reserved.
//

import Foundation
import UIKit


//MARK:UI相关
//320(5),375(6),414(6p)
let screenWidth =  UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let navigatorHeight = 44
//宽高比(点)
let screenPTFactor = screenWidth / 375
//宽高比(像素)
let screenPXFactor = screenWidth / 750



//MARK:存储相关


//判断是iphonex
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
    
    public func isheight960() -> Bool {
        if UIScreen.main.bounds.height <= 480 {
            return true
        }
        return false
    }
}

//MARK:是否是模拟器
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}


