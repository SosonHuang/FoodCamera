//
//  ViewController.swift
//  FoodCamera
//
//  Created by soson on 2018/9/5.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //白板View
    fileprivate lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80)
        whiteView.backgroundColor = UIColor.white
        return whiteView
    }()
    
    //相机View
    fileprivate lazy var cameraView: UIView = {
        let cameraView = UIView()
        cameraView.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150)
        cameraView.backgroundColor = UIColor.white
        return cameraView
    }()
    
    
    //聚焦图片
    fileprivate lazy var focusView: UIImageView = {
        let focusView = UIImageView()
        focusView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        focusView.isHidden = true
        focusView.image = UIImage(named: "take_image_focus")
        return focusView
    }()
    
    
    //顶部View
    fileprivate lazy var topView: TopView = {
        let topView = TopView()
        topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 50)
        topView.backgroundColor = UIColor.clear
        return topView
    }()
    
    //顶部设置View
    fileprivate lazy var topButtomView: TopButtomView = {
        let topButtomView = TopButtomView()
        topButtomView.frame = CGRect(x: 20, y: 70, width: screenWidth - 40, height: 80)
        topButtomView.backgroundColor = UIColor.black
        return topButtomView
    }()
    
    
    //下面的View
    fileprivate lazy var buttomView: ButtomView = {
        let buttomView = ButtomView()
        buttomView.frame =  CGRect(x: 0, y: view.frame.size.height-150, width: view.frame.size.width, height: 150 * screenPTFactor)
        buttomView.backgroundColor = UIColor.white
        return buttomView
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
        //检测相机权限
        if SOCamera.shareCamera.cameraPermissions() == false{
            gotoSetting()
        }
        
        
        self.view.addSubview(cameraView)
        self.view.addSubview(whiteView)
        self.view.addSubview(buttomView)
        
        
        
        
        //普通启动照相机
        SOCamera.shareCamera.start(view: cameraView, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150))
        
        cameraView.addSubview(focusView)
        //设置聚焦图片
        SOCamera.shareCamera.focusView = focusView
        
        //顶部View
        self.view.addSubview(topView)
        self.view.addSubview(topButtomView)
        
        
        
        
        //顶部的按钮点击
        topView.clickBtnBlock = {(tag) in
            switch tag {
                case 0:
                    break
                case 1:
                    break
                case 2:
                    //转换摄像头
                    SOCamera.shareCamera.beforeAfterCamera()
                    break
                default:
                    break
            }
        }
        
        
        
        
    }
    
    
    
    deinit {
        debugPrint("ViewController deinit!!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //去设置权限
    func gotoSetting(){
        let alertController:UIAlertController=UIAlertController.init(title: "请打开相机权限", message: "设置-隐私-相机", preferredStyle: UIAlertControllerStyle.alert)
        let sure:UIAlertAction=UIAlertAction.init(title: "去开启权限", style: UIAlertActionStyle.default) { (ac) in
            let url=URL.init(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!, options: [:], completionHandler: { (ist) in })
            }
        }
        alertController.addAction(sure)
        self.present(alertController, animated: true) { }
    }

}

