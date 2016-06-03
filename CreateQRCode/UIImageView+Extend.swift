//
//  UIImageView+Extend.swift
//  CreateQRCodeDemo
//
//  Created by miaolin on 16/5/13.
//  Copyright © 2016年 赵攀. All rights reserved.
//

import UIKit

extension UIImageView {
    /**
     得到二维码的方法，如果不需要中间的头像可以将iconImage传空或者iconImageSize传0
     
     - parameter iconImage: 二维码中间的头像(穿空时候不显示)
     - parameter message:   生成二维码包含的信息
     - parameter iconImageSize:   头像的大小设置太大容易扫不出二维码建议(20)
     
     - returns: 返回二维码
     */
    func cerateQRCode(iconImage: UIImage?, message: String, iconImageSize: CGFloat) -> UIImageView {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(message.dataUsingEncoding(NSUTF8StringEncoding), forKeyPath: "inputMessage")
        let ciImage = filter?.outputImage
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: self.frame.size.width)
        var newImage = UIImage()
        if iconImage == nil || iconImageSize == 0 {
            newImage = bgImage
        }else {
            newImage = createImage(bgImage, iconImage: UIImage(named: "xuexi8_logo")!, iconImageSize: 50)
        }
        self.image = newImage
        return self
    }
    
    private func createImage(bgImage: UIImage, iconImage: UIImage, iconImageSize: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(bgImage.size)
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        
        let width:CGFloat = iconImageSize
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
}
