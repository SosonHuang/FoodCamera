//
//  SoCamera.swift
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


/**   创建相机对象  **/
class SOCamera: NSObject {
 
    
    //获取设备:如摄像头
    fileprivate var cameraDevice :AVCaptureDevice!
    fileprivate var videoInput : AVCaptureDeviceInput?  //输入流
    fileprivate var settings = AVCapturePhotoSettings()
    ////会话,协调着intput到output的数据传输,input和output的桥梁
    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
//    fileprivate lazy var output:AVCaptureMetadataOutput! //当启动摄像头开始捕获输入
    fileprivate lazy var imageOutput : AVCapturePhotoOutput = AVCapturePhotoOutput() //输出流
    lazy var priviewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer() //图像预览层，实时显示捕获的图像
    fileprivate var currentView: UIView! //管理控制器
    fileprivate var isUsingBackCamera:Bool = true //是否正在使用后置摄像头
 
    
    var focusView :UIView! //聚焦的View
    fileprivate var effectiveScale:CGFloat = 1.0 //默认缩放
    fileprivate var beginGestureScale:CGFloat = 1.0 //
    fileprivate let maxScale:CGFloat = 2.0 //最大缩放
    fileprivate let minScale:CGFloat = 1.0 //最小缩放
    
    //单例
    internal static let shareCamera:SOCamera = {
        let camera = SOCamera()
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

extension SOCamera:AVCapturePhotoCaptureDelegate{
    
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
extension SOCamera:UIGestureRecognizerDelegate{
    
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
//        AVCaptureDeviceTypeBuiltInMicrophone //创建麦克风
//        AVCaptureDeviceTypeBuiltInWideAngleCamera //创建广角相机
//        AVCaptureDeviceTypeBuiltInTelephotoCamera //创建比广角相机更长的焦距。只有使用 AVCaptureDeviceDiscoverySession 可以使用
//        AVCaptureDeviceTypeBuiltInDualCamera //创建变焦的相机，可以实现广角和变焦的自动切换。使用同AVCaptureDeviceTypeBuiltInTelephotoCamera 一样。
//        AVCaptureDeviceTypeBuiltInDuoCamera //iOS 10.2 被 AVCaptureDeviceTypeBuiltInDualCamera 替换
        
      
        // Choose the back dual camera if available, otherwise default to a wide angle camera.
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            cameraDevice = dualCameraDevice
        }
            
        else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            cameraDevice = backCameraDevice
        }
            
        else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            cameraDevice = frontCameraDevice
        }
        
       
        guard let inputDevice = try? AVCaptureDeviceInput(device: cameraDevice!) else { return }
        self.videoInput = inputDevice
        
        //输出
        imageOutput = AVCapturePhotoOutput()
        settings.livePhotoVideoCodecType = .jpeg
        //支持自动闪光灯
        settings.flashMode = .auto
        
        
        
        //加入
        if session.canAddInput(inputDevice) == true {
            session.addInput(self.videoInput!)
        }
        if session.canAddOutput(imageOutput) == true {
            session.addOutput(imageOutput)
        }
        
        //视图
        priviewLayer = AVCaptureVideoPreviewLayer(session:session)
        priviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    
        
    }
    
    //显示View
    fileprivate func addPrviewLayerToView(frame:CGRect) -> Void{
        priviewLayer.frame = frame
        //currentView.layer.masksToBounds = true
        currentView.layer.insertSublayer(priviewLayer, at: 0)
    }
    
    
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
        
        do{ try cameraDevice.lockForConfiguration() }catch{ }
        
        
        
        cameraDevice.focusPointOfInterest = currentPoint
        cameraDevice.focusMode = .continuousAutoFocus
        
        cameraDevice.exposurePointOfInterest = currentPoint
        cameraDevice.exposureMode = .continuousAutoExposure
       
        cameraDevice.unlockForConfiguration()
        focusView.center = currentPoint
        focusView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.focusView.transform = CGAffineTransform.identity
            }) { (_) in
                self.focusView.isHidden = true
            }
        }
        
        
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
        
        let maxScaleAndCropFactor : CGFloat = (imageOutput.connection(with: .video)?.videoMaxScaleAndCropFactor)!
        
        if  self.effectiveScale > maxScaleAndCropFactor {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.025)
        priviewLayer.setAffineTransform(CGAffineTransform(scaleX: effectiveScale, y: effectiveScale))
        CATransaction.commit()
    }
    
    
    
    //MARK:相机配置相关
    //MARK:切换前后置摄像头，闪光灯
    func beforeAfterCamera(){
        //获取之前的镜头
        guard var position = videoInput?.device.position else { return }
        //获取当前应该显示的镜头
        position = position == .front ? .back : .front
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: position) {
            cameraDevice = dualCameraDevice
        }
            
        else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position) {
            cameraDevice = backCameraDevice
        }
            
        else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position) {
            cameraDevice = frontCameraDevice
        }        //input
        guard let videoInput = try? AVCaptureDeviceInput(device: cameraDevice) else { return }
        
        //切换
        session.beginConfiguration()
        session.removeInput(self.videoInput!)
        session.addInput(videoInput)
        session.commitConfiguration()
        self.videoInput = videoInput
    }
    
//    func flashCamera(mode:flashMode){
//        do{ try cameraDevice.lockForConfiguration() }catch{ }
//        if cameraDevice.hasFlash == false { return }
//        if mode.rawValue == 0 { cameraDevice.flashMode = .off}
//        if mode.rawValue == 1 { cameraDevice.flashMode = .on}
//        if mode.rawValue == 2 { cameraDevice.flashMode = .auto}
//        
//        cameraDevice.unlockForConfiguration()
//    }
    
    //MARK:开始和停止
    func start(view: UIView , frame: CGRect){
        currentView = view
        addPrviewLayerToView(frame: frame)
        setUpGesture() //添加手势
        if session.isRunning == false {
            session.startRunning()
        }
    }
    
    func stop(){
        if session.isRunning == true {
            session.stopRunning()
        }
    }
 
    //MARK:拍照
    func takePhoto(finishedCallback :  @escaping (_ result : UIImage ) -> ()){
        let captureConnetion = imageOutput.connection(with: .video)
        captureConnetion?.videoScaleAndCropFactor = effectiveScale
        if captureConnetion == nil {
            print("take photo failed!")
            return
        }
        imageOutput.capturePhoto(with: settings, delegate: self )
        
        
        
        
        //
        
    }
        
//        imageOutput.captureStillImageAsynchronously(from: captureConnetion) { (imageBuffer, error) in
//            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer)
//            let jpegImage = UIImage(data: jpegData!)
//
//            //这里你可以 生成任意大小的图片
//            //jpegImage = jpegImage.rotate(aImage: jpegImage)
//
//            //图片入库
//            UIImageWriteToSavedPhotosAlbum(jpegImage!, self,nil, nil)
//            finishedCallback(jpegImage!)
//        }
//    }
    
    //图片中截取图片
    //拍完照片后一般是整张图片，如果想要截取某一部分使用此方法
    func getImageFromImage(oldImage:UIImage,newImageRect:CGRect) ->UIImage {
        let imageRef = oldImage.cgImage;
        let subImageRef = imageRef!.cropping(to: newImageRect);
        return UIImage(cgImage: subImageRef!)
    }

}
