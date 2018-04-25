//
//  UIImageViewExtension.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/25.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit

extension UIImage {
    /// 画像を正方形にクリッピングする
    ///
    /// - Returns: クリッピングされた正方形の画像
    func cropping2square()-> UIImage!{
        let cgImage    = self.cgImage
        let width = (cgImage?.width)!
        let height = (cgImage?.height)!
        let resizeSize = min(height,width)
        
        let cropCGImage = self.cgImage?.cropping(to: CGRect(x: (width - resizeSize) / 2, y: (height - resizeSize) / 2, width: resizeSize, height: resizeSize))
        
        let cropImage = UIImage(cgImage: cropCGImage!)
        
        return cropImage//.rotate(angle: 90)
    }
    /// 画像をを回転させる
    ///
    /// - Parameter angle: 回転角度(deg)
    /// - Returns: 回転された画像
    func rotate(angle: CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width, height: self.size.height), false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let radian: CGFloat = (-angle) * CGFloat.pi / 180.0
        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let rotatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
    
    private func min(_ a : Int, _ b : Int ) -> Int {
        if a < b { return a}
        else { return b}
    }
}
