//
//  DCAlbumCollectionViewCell.swift
//  Chihiro
//
//  Created by point on 2016/11/7.
//  Copyright © 2016年 chihiro. All rights reserved.
//

import UIKit

class DCAlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
//    @IBOutlet weak var timlbl: UILabel!
    @IBOutlet weak var timelabl: UIButton!
    var representedAssetIdentifier: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        closeBtn.isHidden = true
        closeBtn.isUserInteractionEnabled = false
        albumImage.contentMode = .scaleAspectFill
        albumImage.layer.masksToBounds = true
//        albumImage.contentMode = .scaleAspectFit
    }

}
