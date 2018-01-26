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
     
     - parameter iconImage: 二维码中间的头像(传空时候不显示)
     - parameter message:   生成二维码包含的信息
     - parameter iconImageSize:   头像的大小设置太大容易扫不出二维码建议(20)
     
     - returns: 返回二维码
     */
    func cerateQRCode(iconImage: UIImage?, message: String, iconImageSize: CGFloat) {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(message.data(using: .utf8), forKey: "inputMessage")
        let ciImage = filter?.outputImage
        let bgImage = createNonInterpolatedUIImageFormCIImage(image: ciImage!, size: self.frame.size.width)
        var newImage = UIImage()
        if iconImage == nil || iconImageSize == 0 {
            newImage = bgImage
        }else {
            newImage = createImage(bgImage: bgImage, iconImage: iconImage!, iconImageSize: iconImageSize)
        }
        self.image = newImage
    }
    
    private func createImage(bgImage: UIImage, iconImage: UIImage, iconImageSize: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(bgImage.size)
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        
        let width:CGFloat = iconImageSize
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: scaledImage)
    }
}
