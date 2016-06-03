//
//  ViewController.swift
//  CreateQRCodeDemo
//
//  Created by miaolin on 16/5/13.
//  Copyright © 2016年 赵攀. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.cerateQRCode(UIImage(named: "xuexi8_logo"), message: "学习8", iconImageSize: 20)
    }


}

