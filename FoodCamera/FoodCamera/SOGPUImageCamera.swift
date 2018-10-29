//
//  SOGPUImageCamera.swift
//  FoodCamera
//
//  Created by soson on 2018/9/6.
//  Copyright © 2018年 soson. All rights reserved.
//

/**
 
 
 普通相机
 
 
 **/
import UIKit
import AVFoundation
import GPUImage

enum flashMode:Int {
    case off
    case on
    case auto
}

/**   创建相机对象  **/
class SOGPUImageCamera: NSObject {
 
    
    // 相机控件
    var currentView:GPUImageView!
    var _stillCamera:GPUImageStillCamera!
    var _filter:GPUImageFilter!
    var _previewLayer:AVCaptureVideoPreviewLayer!
  
//    fileprivate var currentView: UIView! //管理控制器
    
   
    var focusView :UIView! //聚焦的View
    fileprivate var effectiveScale:CGFloat = 1.0 //默认缩放
    fileprivate var beginGestureScale:CGFloat = 1.0 //
    fileprivate let maxScale:CGFloat = 2.0 //最大缩放
    fileprivate let minScale:CGFloat = 1.0 //最小缩放
    
    //单例
    internal static let shareCamera:SOGPUImageCamera = {
        let camera = SOGPUImageCamera()
        return camera
    }()
    
    //初始化
    override init() {
        super.init()
        if Platform.isSimulator {
            print("请不要使用模拟器测试")
        }
        else {
            installCameraDevice() //初始化摄像机
            
        }
    }
}

extension SOGPUImageCamera:AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
     
    }
}

// MARK: - 初始化相机,权限相关
extension SOGPUImageCamera:UIGestureRecognizerDelegate{
    
//    AVAuthorizationStatusNotDetermined = 0,//用户暂时没有做相关选着
//    AVAuthorizationStatusRestricted    = 1,//没有改媒体类型
//    AVAuthorizationStatusDenied        = 2,//用户拒绝
//    AVAuthorizationStatusAuthorized    = 3,//用户允许
    
   
    /** 相机权限检测 */
    //Privacy - Camera Usage Description
    func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
//            AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authStatus {
        case .denied , .restricted:
            
            return false
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (flag) in }
            return true
        }
    }
    

    
    
    fileprivate func installCameraDevice(){

       

        if UIDevice.current.isheight960() {
            _stillCamera = GPUImageStillCamera(sessionPreset: "AVCaptureSessionPreset640x480", cameraPosition: .back)
        }else{
            _stillCamera = GPUImageStillCamera(sessionPreset: "AVCaptureSessionPreset1280x720", cameraPosition: .back)
        }
        
        _stillCamera.outputImageOrientation = .portrait
        _stillCamera.horizontallyMirrorFrontFacingCamera = true;
        
        
        if ((try? _stillCamera.inputCamera.lockForConfiguration()) != nil) {
            //            if _stillCamera.inputCamera.isFlashModeSupported(.auto) {
            //                _stillCamera.inputCamera.flashMode = .auto
            //            }
            //自动白平衡
            if _stillCamera.inputCamera.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                _stillCamera.inputCamera.whiteBalanceMode = .autoWhiteBalance
            }
            
            _stillCamera.inputCamera.unlockForConfiguration()
        }

        
    }
    
    //显示View
//    fileprivate func addPrviewLayerToView(frame:CGRect) -> Void{
//        priviewLayer.frame = frame
//        //currentView.layer.masksToBounds = true
//        currentView.layer.insertSublayer(priviewLayer, at: 0)
//    }
    
    
    //添加手势 + 缩放 + 聚焦
    fileprivate func setUpGesture() {
        let pinGesutre = UIPinchGestureRecognizer(target: self, action: #selector(pinFunc(_:)))
        pinGesutre.delegate = self
        currentView.addGestureRecognizer(pinGesutre)
        
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(tipFunc(_:)))
        currentView.addGestureRecognizer(tapGesutre)
    }
    
    //添加上聚焦
    @objc func tipFunc(_ ges:UITapGestureRecognizer) {
        let currentPoint  = ges.location(in: currentView)
        currentView.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.currentView.isUserInteractionEnabled = true
        }
        
//        do{ try cameraDevice.lockForConfiguration() }catch{ }
//
//
//
//        cameraDevice.focusPointOfInterest = currentPoint
//        cameraDevice.focusMode = .continuousAutoFocus
//
//        cameraDevice.exposurePointOfInterest = currentPoint
//        cameraDevice.exposureMode = .continuousAutoExposure
//
//        cameraDevice.unlockForConfiguration()
//        focusView.center = currentPoint
//        focusView.isHidden = false
//        UIView.animate(withDuration: 0.3, animations: {
//            self.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
//        }) { (_) in
//            UIView.animate(withDuration: 0.5, animations: {
//                self.focusView.transform = CGAffineTransform.identity
//            }) { (_) in
//                self.focusView.isHidden = true
//            }
//        }
        
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer .isKind(of: UIPinchGestureRecognizer.classForCoder()) {
            beginGestureScale = self.effectiveScale
        }
        return true
    }
    
    //添加缩放
    @objc func pinFunc(_ recognizer:UIPinchGestureRecognizer) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0) {
            self.effectiveScale = 1.0;
        }
        
//        let maxScaleAndCropFactor : CGFloat = (imageOutput.connection(with: .video)?.videoMaxScaleAndCropFactor)!
//
//        if  self.effectiveScale > maxScaleAndCropFactor {
//            self.effectiveScale = maxScaleAndCropFactor;
//        }
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(0.025)
//        priviewLayer.setAffineTransform(CGAffineTransform(scaleX: effectiveScale, y: effectiveScale))
//        CATransaction.commit()
    }
    
    
    
    //MARK:相机配置相关
    //MARK:切换前后置摄像头，闪光灯
    func beforeAfterCamera(){
       _stillCamera.rotateCamera()
    }
    
    func flashCamera(mode:flashMode){
        
        do{ try _stillCamera.inputCamera.lockForConfiguration() }catch{ }
        if _stillCamera.inputCamera.hasFlash == false { return }
        if mode.rawValue == 0 { _stillCamera.inputCamera.flashMode = .off}
        if mode.rawValue == 1 { _stillCamera.inputCamera.flashMode = .on}
        if mode.rawValue == 2 { _stillCamera.inputCamera.flashMode = .auto}
        _stillCamera.inputCamera.unlockForConfiguration()
    }
    
    //MARK:开始和停止
    func start(view: GPUImageView , frame: CGRect){
        currentView = view
//        _previewLayer = AVCaptureVideoPreviewLayer(session: _stillCamera.captureSession)
//        _previewLayer.videoGravity = .resizeAspect
//        _previewLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        _previewLayer.masksToBounds = true
//        currentView.layer.addSublayer(_previewLayer)

        setUpGesture() //添加手势
        _stillCamera.startCapture()
        
        
//       加入滤镜
//        _filter = GPUImageSketchFilter()
//        _stillCamera.addTarget(_filter)
//        _filter.addTarget(currentView)
        
        //不使用滤镜
        SOGPUImageCamera.shareCamera._stillCamera.addTarget(SOGPUImageCamera.shareCamera.currentView)

    }
    
    func stop(){
        _stillCamera.stopCapture()
    }
 
    //MARK:拍照
    func takePhoto(finishedCallback :  @escaping (_ result : UIImage ) -> ()){
     
        _stillCamera.capturePhotoAsImageProcessedUp(toFilter: _filter, withCompletionHandler: {(_ image: UIImage?, _ error: Error?) -> Void in
            
            print("image.size:\(image?.size)")
            //将图片转成 3:4 比例
            let finalImage = image!.crop(ratio: 3/4)
            
            //将图片转成 4:3 比例
            let test43 = image!.crop(ratio: 3/4)
            
            //将图片转成 1:1 比例（正方形）
            let test1bi1 = image!.crop(ratio: 1)
            

            SOAlbumItem.shareAlbumItem.savePhoto(finalImage)//            保存图片
            finishedCallback(finalImage)
        })
    }
    
    
}


extension UIImage {
    
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
