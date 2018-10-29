//
//  DCAlbumListViewController.swift
//  Chihiro
//
//  Created by point on 2016/11/7.
//  Copyright © 2016年 chihiro. All rights reserved.
//

import UIKit
import Photos

private let kDCAlbumListCellID = "kDCAlbumListCellID"
private let kCellWidth = screenWidth/3


class DCAlbumListViewController: UIViewController {
    
//    var imgArr = [UIImage]() {
//        didSet {
//            collectionView.reloadData()
//
//        }
//    }
    
    
      var fetchResult: PHFetchResult<PHAsset>!
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    // MARK:- 懒加载属性
    lazy var collectionView : UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kCellWidth, height: kCellWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        
        collectionView.dataSource  = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "DCAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kDCAlbumListCellID)
        return collectionView
        }()
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        
        resetCachedAssets()
//        PHPhotoLibrary.shared().register(self)
        
        // If we get here without a segue, it's because we're visible at app launch,
        // so match the behavior of segue from the default "All Photos" view.
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
        
        
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: kCellWidth * scale, height: kCellWidth * scale)
        
        let btn = UIButton()
        btn.setTitle("退出", for: .normal)
        btn.frame = CGRect(x: 100, y:screenHeight-100 , width: 100, height: 100)
        view.addSubview(btn)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc fileprivate func btnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}



extension DCAlbumListViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let asset = fetchResult.object(at: indexPath.item)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDCAlbumListCellID, for: indexPath) as! DCAlbumCollectionViewCell
        cell.backgroundColor = UIColor.white
//        cell.albumImage.image = imgArr[indexPath.row]
        
        
       
        // Add a badge to the cell if the PHAsset represents a Live Photo.
        if asset.mediaSubtypes.contains(.photoLive) {
//            cell.livePhotoBadgeImage = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        }
        
        if asset.mediaType == .video {
            print(Float(asset.duration))
            //视频总时长
//            cell.timlbl.text = "\(Float(asset.duration))"
            
            //            cell.livePhotoBadgeImage = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        }
        
        // Request an image for the asset from the PHCachingImageManager.
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.albumImage.image = image
            }
        })
        
        
        
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}

