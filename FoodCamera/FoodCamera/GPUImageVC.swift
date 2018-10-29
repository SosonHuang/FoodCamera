//
//  ViewController.swift
//  FoodCamera
//
//  Created by soson on 2018/9/5.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit
import GPUImage
import Photos

class GPUImageVC: UIViewController {
    
    
    //白板View
    fileprivate lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        whiteView.backgroundColor = UIColor.white
        return whiteView
    }()
    
    //相机View
    fileprivate lazy var cameraView: GPUImageView = {
        let cameraView = GPUImageView()
        cameraView.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
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
    fileprivate lazy var scrollview: FilterScrollView = {
        let scrollview = FilterScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: screenHeight - 150 * screenPTFactor))
        scrollview.numOfPages = 10
        scrollview.pageHeight = Int(screenHeight - 150 * screenPTFactor)
//        scrollview.backgroundColor = UIColor.red
        return scrollview
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
//        self.view.addSubview(whiteView)
        self.view.addSubview(buttomView)
        
        
        
//        cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        //普通启动照相机
        SOGPUImageCamera.shareCamera.start(view: cameraView, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150))
        
        //把透明的scrollview加入相机上层
        SOGPUImageCamera.shareCamera.currentView.addSubview(scrollview)
        
//        cameraView.addSubview(focusView)
        //设置聚焦图片
        SOGPUImageCamera.shareCamera.focusView = focusView
//
//        //顶部View
        self.view.addSubview(topView)
        self.view.addSubview(topButtomView)
        
        
        buttomView.clickButtomBlock = {(tag) in
            switch tag {
            case 0:
                let vc = DCAlbumViewController()
                vc.dcAlbumItem =  SOAlbumItem.shareAlbumItem.getAlbumItem()
                self.present(vc, animated: true, completion: nil)
                break
            case 1:
                
                SOGPUImageCamera.shareCamera.takePhoto { [unowned self] (image) in
                    let vc = ImageViewController()
                    vc.image = image
                    self.present(vc, animated: true, completion: nil)
                }
                break
            case 2:
         

                
                //-----------------------------------------------------------
                
                
//                //你还可以这样做 你可以查看任何一个相册  需要一定的等待时间 所以是回调
//                let itemArr = SOAlbumItem.shareAlbumItem.getAlbumItem()
//            SOAlbumItem.shareAlbumItem.getAlbumItemFetchResultsDefault(thumbnailSize:PHImageManagerMaximumSize )
//                { [unowned self] (imgarr) in
//
//                    let vc = DCAlbumListViewController()
//                    vc.imgArr = imgarr
//                    self.present(vc, animated: true, completion: nil)
//                }
                
                
                
                
                //-----------------------------------------------------------
                
                let scale = UIScreen.main.scale + 1
                
                
                let size = CGSize(width: screenWidth/3 * scale, height: screenWidth/3 * scale)

                //你还可以这样做 你可以查看任何一个相册  需要一定的等待时间 所以是回调
                let itemArr = SOAlbumItem.shareAlbumItem.getAlbumItem()
                let resulet  = itemArr.first?.fetchResult
              
//
//                SOAlbumItem.shareAlbumItem.getAlbumItemFetchResults(assetsFetchResults: resulet!, thumbnailSize: size) { [unowned self] (imgarr) in
//
//                    let vc = DCAlbumListViewController()
//                    vc.imgArr = imgarr
//                    self.present(vc, animated: true, completion: nil)
//
//                }
                
                let vc = DCAlbumListViewController()
                vc.fetchResult = resulet
                self.present(vc, animated: true, completion: nil)
                break
            default:
                break
            }
        }
        
        
        //顶部的按钮点击
        topView.clickBtnBlock = {(tag) in
            switch tag {
                case 0:
                    break
                case 1:
                    //清楚滤镜
                    SOGPUImageCamera.shareCamera._stillCamera.removeAllTargets()
                    //（褐色）
                    var _filter:GPUImageSepiaFilter = GPUImageSepiaFilter()
                    // 添加 target（链式串联）
                    
                    SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                    _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                    SOGPUImageCamera.shareCamera._filter = _filter
               

                    
                //色阶    里面很多参数
//                    var _filter:GPUImageLevelsFilter = GPUImageLevelsFilter()
//                    // 添加 target（链式串联）
//                    SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
//                    _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)

                    
//                    var _filter:GPUImageLevelsFilter = GPUImageLevelsFilter()
//                    // 添加 target（链式串联）
//                    SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
//                    _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)

                    
                    //灰度
//                    var _filter:GPUImageGrayscaleFilter = GPUImageGrayscaleFilter()
//                    // 添加 target（链式串联）
//                    SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
//                    _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                    
                    
//                    色彩直方图，显示在图片上
//                    #import "GPUImageHistogramFilter.h"                 //色彩直方图，显示在图片上
//                    #import "GPUImageHistogramGenerator.h"              //色彩直方图
//                    #import "GPUImageRGBFilter.h"                       //RGB
//                    #import "GPUImageToneCurveFilter.h"                 //色调曲线
//                    #import "GPUImageMonochromeFilter.h"                //单色
//                    #import "GPUImageHighlightShadowFilter.h"           //提亮阴影
//                      44 #import "GPUImageFalseColorFilter.h"                //色彩替换（替换亮部和暗部色彩）
//                      45 #import "GPUImageHueFilter.h"                       //色度
//                      46 #import "GPUImageChromaKeyFilter.h"                 //色度键
//                      47 #import "GPUImageWhiteBalanceFilter.h"              //白平横
//                      48 #import "GPUImageAverageColor.h"                    //像素平均色值
//                      49 #import "GPUImageSolidColorGenerator.h"             //纯色
//                      50 #import "GPUImageLuminosity.h"                      //亮度平均
//                      51 #import "GPUImageAverageLuminanceThresholdFilter.h" //像素色值亮度平均，图像黑白（有类似漫画效果）
//                      52
//                      53 #import "GPUImageLookupFilter.h"                    //lookup 色彩调整
//                      54 #import "GPUImageAmatorkaFilter.h"                  //Amatorka lookup
//                      55 #import "GPUImageMissEtikateFilter.h"               //MissEtikate lookup
//                      56 #import "GPUImageSoftEleganceFilter.h"              //SoftElegance lookup
                    
                 
            

                    
                    break
                case 2:
                    //转换摄像头
                    SOGPUImageCamera.shareCamera.beforeAfterCamera()
                    break
                default:
                    break
            }
        }
        
        
        
        topButtomView.clickTopButtomBlock = {(tag) in
            
            
            switch tag {
            case 0:
                SOGPUImageCamera.shareCamera.flashCamera(mode: .on)
                break
            case 1:
                
                break
            case 2:
                break
            default:
                break
            }
        }
        
        
        //滚动scrollview切换滤镜
        scrollview.scrollviewBlock = {(tag) in
            //清楚滤镜
            SOGPUImageCamera.shareCamera._stillCamera.removeAllTargets()
            
            switch tag{
            case 0:
                //不使用滤镜
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(SOGPUImageCamera.shareCamera.currentView)

               
                break
            case 1:
//                亮度
                var _filter:GPUImageBrightnessFilter = GPUImageBrightnessFilter()
                // 添加 target（链式串联）
                _filter.brightness = -0.3   //-1.0 to 1.0
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 2:
                //曝光
                var _filter:GPUImageExposureFilter = GPUImageExposureFilter()
                // 添加 target（链式串联）
                _filter.exposure = 1   //-10.0 to 10.0
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 3:
                //对比度
                var _filter:GPUImageContrastFilter = GPUImageContrastFilter()
                // 添加 target（链式串联）
                _filter.contrast = 3.0   //0.0 to 4.0
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 4:
                //反色
                var _filter:GPUImageColorInvertFilter = GPUImageColorInvertFilter()
                // 添加 target（链式串联）

                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 5:
                //黑白滤镜
                var _filter:GPUImageOpeningFilter = GPUImageOpeningFilter()
                // 添加 target（链式串联）

                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
//                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 6:
                //饱和度
                var _filter:GPUImageSaturationFilter = GPUImageSaturationFilter()
                // 添加 target（链式串联）
                _filter.saturation = 1.5   //0.0 (fully desaturated) to 2.0
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 7:
                //伽马线
                var _filter:GPUImageGammaFilter = GPUImageGammaFilter()
                // 添加 target（链式串联）
                _filter.gamma = 3.0   //0.0 to 3.0
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 8:
                //                //溶解
//                var _filter:GPUImageDissolveBlendFilter = GPUImageDissolveBlendFilter()
//                _filter.mix = 1.0
//                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
//                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                
                var _filter = GPUImageSketchFilter()
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
                break
            case 9:
                //反色
                var _filter:GPUImageSepiaFilter = GPUImageSepiaFilter()
                // 添加 target（链式串联）
                
                SOGPUImageCamera.shareCamera._stillCamera.addTarget(_filter)
                _filter.addTarget(SOGPUImageCamera.shareCamera.currentView)
                SOGPUImageCamera.shareCamera._filter = _filter
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

