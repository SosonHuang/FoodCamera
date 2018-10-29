//
//  ImageViewController.swift
//  FoodCamera
//
//  Created by soson on 2018/9/30.
//  Copyright © 2018年 soson. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image :UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        
        // Do any additional setup after loading the view.
        let iv = UIImageView()   // 图片
        iv.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 150 * screenPTFactor)
        iv.image = image!
        // 添加到view上
        self.view.addSubview(iv)
        
        
        let backbutton = UIButton()   // 返回
        backbutton.frame = CGRect(x: 50, y: 50, width: 100, height: 50)
        backbutton.backgroundColor = UIColor.red
        backbutton.setTitle("返回", for: .normal)
        backbutton.addTarget(self, action: #selector(btnClick(_:)), for: .touchDown)
        // 添加到view上
        self.view.addSubview(backbutton)
    }
    
    
    @objc func btnClick(_ btn:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
