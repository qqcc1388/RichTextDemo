//
//  UIImage+FastKit.swift
//  hxquan-swift
//
//  Created by Tiny on 2018/11/7.
//  Copyright © 2018年 hxq. All rights reserved.
//

import Foundation

extension UIImage{
    
    func savedPhotosAlbum(completeBlock: ((Bool)->Void)?){
        let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "completeBlock".hashValue)
        objc_setAssociatedObject(self, key, completeBlock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        
        let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "completeBlock".hashValue)
        if let completeBlock = objc_getAssociatedObject(self, key) as? ((Bool)->Void) {
            if error == nil {
                //保存成功
                completeBlock(true)
            }else{
                //保存失败
                completeBlock(false)
            }
        }
    }
    
    /// 将颜色转变成制定大小的图片并返回
    static func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        if size.width < 0 || size.height < 0 {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        if let context = UIGraphicsGetCurrentContext(){
            context.setFillColor(color.cgColor);
            context.fill(rect);
            if let image = UIGraphicsGetImageFromCurrentImageContext(){
                UIGraphicsEndImageContext();
                return image
            }
        }
        return nil
    }
    
    
    /// 图片等比例缩放
    func imageByResizeToSize(size: CGSize) -> UIImage?{
        if size.width < 0 || size.height < 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext();
            return image
        }
        return nil
    }
}
