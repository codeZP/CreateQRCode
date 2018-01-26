//
//  ViewController.swift
//  CreateQRCodeDemo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 ZP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageV.cerateQRCode(iconImage: UIImage(named: "QQ20171218-0的副本 6-5"), message: "https://www.baidu.com/", iconImageSize: 30)
    }


}

