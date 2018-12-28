//
//  MBProgressHUD+FastKit.swift
//  t1
//
//  Created by Tiny on 2018/10/24.
//  Copyright © 2018年 hxq. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    
    /// MBProgressHUD gif显示
    ///
    /// - Parameters:
    ///   - view: view default -> UIWindow
    ///   - disableInteraction: 是否使能交互
    ///   - animated: 动画 true
    static func showGif(to view:UIView? = nil,disableInteraction:Bool = true,animated:Bool = true){
        //如果是gif可以使用sdwebImage的方法加载本地gif
        let path = Bundle.main.path(forResource: "test", ofType: "gif")
        let data = NSData(contentsOfFile: path ?? "") as Data?
        guard let image = UIImage.sd_animatedGIF(with: data) else{
            fatalError("gif图片加载失败");
        }
        let giftImgView = UIImageView(image: image)
        let hud = MBProgressHUD.showHudAdded(to: view, animated: animated)
        hud?.color = .clear
        hud?.mode = .customView
        hud?.isUserInteractionEnabled = disableInteraction
        hud?.customView = giftImgView
    }
    
    /// 拓展MBProgressHUD显示方法
    ///
    /// - Parameters:
    ///   - message: text
    ///   - icon: picture
    ///   - view: view default->UIwindow
    ///   - disableInteraction: 是否使能交互
    ///   - afterDelay: 延时 默认0
    ///   - animated: 动画 true
    static func show(message:String? = nil ,
                     icon:String? = nil ,
                     to view:UIView? = nil,
                     disableInteraction:Bool = true,
                     afterDelay:TimeInterval = 0,
                     animated:Bool = true){
        
        let hud = self.showHudAdded(to: view, animated: true)
        hud?.isUserInteractionEnabled = disableInteraction
        hud?.labelText = message
        if let image = UIImage(named: "MBProgressHUD.bundle/\(icon ?? "")") {
            let imgView = UIImageView(image: image)
            hud?.customView = imgView
            hud?.mode = .customView
        }
        if afterDelay > 0.0 {
            hud?.hide(true, afterDelay: afterDelay)
        }
    }
    
    /// 移除keywindow的hud
    static func hide(){
       let v = UIApplication.shared.windows.last;
       hide(for: v, animated: true)
    }
    
    static func showSuccess(_ message:String = "",to view:UIView? = nil){
        show(message: message, icon: "success.png", to: view ,afterDelay: 2.0)
    }
    
    static func showError(_ message:String = "",to view:UIView? = nil){
        show(message: message, icon: "error.png", to: view ,afterDelay: 2.0)
    }
    
    private  static func showHudAdded(to view:UIView? = nil,animated:Bool = true) -> MBProgressHUD?{
        var v = view
        if v == nil {
            v = UIApplication.shared.windows.last;
        }
        hide(for: v, animated: true)
        let hud = MBProgressHUD.showAdded(to: v, animated: animated);
        hud?.dimBackground = false
        hud?.removeFromSuperViewOnHide = true
        return hud

    }
}
