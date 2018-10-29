//
//  SoAlbumItem.swift
//  FoodCamera
//
//  Created by soson on 2018/9/6.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit
import Photos
import PhotosUI


/**  操作相册相关的类  **/
class SOAlbumItem: NSObject {

    
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
    fileprivate var items:[SOAlbumItem] = [] //相册列表
    fileprivate var imageManager:PHCachingImageManager! //带缓存的图片管理对象
    
    init(title:String?,fetchResult:PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
    
    
    override init() {
        self.title = nil
        self.fetchResult = PHFetchResult<PHAsset>()
    }
  
    //单例
    internal static let shareAlbumItem:SOAlbumItem = {
        let camera = SOAlbumItem()
        return camera
    }()
    
    
}


// MARK: - 获取相册列表
extension SOAlbumItem {
    
    /** 相册权限检测 */
    //Privacy - Photo Library Usage Description
    func photoPermissions() -> Bool{
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            let vc = UIImagePickerController()
            vc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            return true
        }
    }
    
    //保存图片到相册
    func savePhoto(_ image:UIImage){
        do {
            try PHPhotoLibrary.shared().performChangesAndWait{
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        } catch { }
    }

    
    //MARK: 获取相册的列表ß
    func getAlbumItem() -> [SOAlbumItem]{
        items.removeAll()
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: PHAssetCollectionSubtype.albumRegular,
                                                                  options: smartOptions)
        self.convertCollection(smartAlbums as! PHFetchResult<AnyObject>)
        
        //列出所有用户创建的相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.convertCollection(userCollections as! PHFetchResult<AnyObject>)
        
        //相册按包含的照片数量排序（降序）
        self.items.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }
        return items
        
    }
    
    //转化处理获取到的相簿
    fileprivate func convertCollection(_ collection:PHFetchResult<AnyObject>){
        
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            //筛选只是图片的，如果全部都显示z出来注释即可
//            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
            guard let c = collection[i] as? PHAssetCollection else { return }
            let assetsFetchResult = PHAsset.fetchAssets(in: c,options: resultsOptions)
            //没有图片的空相簿不显示
//            if assetsFetchResult.count > 0{
                self.items.append(SOAlbumItem(title: c.localizedTitle, fetchResult: assetsFetchResult ))
//            }
        }
    }
    
    // MARK: - 获取指定图片
    func getOriginalPicture(picAsset:PHAsset , finishedCallback: @escaping (_ image: UIImage) -> ()) {
        PHImageManager.default().requestImage(for: picAsset,
                                              targetSize: PHImageManagerMaximumSize , contentMode: .default,
                                              options: nil, resultHandler: {
                                                (image, _: [AnyHashable: Any]?) in
                                                finishedCallback(image!)
        })
    }
    
    // MARK: - 获取指定的相册缩略图列表
    func getAlbumItemFetchResults(assetsFetchResults: PHFetchResult<PHAsset> , thumbnailSize: CGSize , finishedCallback: @escaping (_ result : [UIImage] ) -> ()){
        cachingImageManager()
        let imageArr = fetchImage(assetsFetchResults: assetsFetchResults, thumbnailSize: thumbnailSize)
        finishedCallback(imageArr)
    }
    
    // MARK: - 获取默认的照相机照片缩略图列表
    func getAlbumItemFetchResultsDefault(thumbnailSize: CGSize , finishedCallback: @escaping (_ result : [UIImage] ) -> ()) {
        cachingImageManager()
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        //只获取图片
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
        let assetsFetchResults = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        let imageArr = fetchImage(assetsFetchResults: assetsFetchResults, thumbnailSize: thumbnailSize)
        finishedCallback(imageArr)
        
    }
    
    //缓存管理
    fileprivate func cachingImageManager(){
        imageManager = PHCachingImageManager()
        imageManager.stopCachingImagesForAllAssets()
    }
    
    //获取图片
    fileprivate func fetchImage(assetsFetchResults:  PHFetchResult<PHAsset> , thumbnailSize: CGSize) -> [UIImage] {
        var imageArr:[UIImage] = []
        for i in 0..<assetsFetchResults.count {
            let asset = assetsFetchResults[i]
            
            let options = PHImageRequestOptions()
//            options.isSynchronous = true
//            options.deliveryMode = .highQualityFormat
//            options.isNetworkAccessAllowed = true
            options.resizeMode = .exact
            
            self.imageManager.requestImage(for: asset, targetSize: thumbnailSize,
                                           contentMode: .default,
                                           options: options) { (image, nfo) in
                                            imageArr.append(image!)
            }
        }
        return imageArr
    }
}
