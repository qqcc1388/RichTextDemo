//
//  UIView+FastKit.swift
//  t1
//
//  Created by Tiny on 2018/10/23.
//  Copyright © 2018年 hxq. All rights reserved.
//

import UIKit

//MARK:- UIView Tap事件分类
extension UIView{
    
    func fk_addGesture(FKGestureBlock:((UIView)->Void)?){
        let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fk_addGesture".hashValue)
        objc_setAssociatedObject(self, key, FKGestureBlock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func viewTapAction(_ tap: UIGestureRecognizer){
        let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "fk_addGesture".hashValue)
        if let tapBlock = objc_getAssociatedObject(self, key) as? ((UIView)->Void) {
            tapBlock(tap.view!)
        }
    }
}

//MARK:- UIView 常用frame方法分类
extension UIView{
    
    var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame;
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame;
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var frame = self.frame;
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame = self.frame;
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    func change(index:Int) -> Void {
        
    }
}
