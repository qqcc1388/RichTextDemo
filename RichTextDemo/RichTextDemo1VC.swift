//
//  RichTextDemo1VC.swift
//  RichTextDemo
//
//  Created by Tiny on 2018/12/28.
//  Copyright © 2018年 hxq. All rights reserved.
//

import UIKit

class RichTextDemo1VC: UIViewController{
        
    var html: String!
    
    var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        html = "<p><img src=\"http://oss.hxquan.cn/bd/e0-27817083505076241.jpg\" title=\"迪丽热巴banner没有LOGO.jpg\" alt=\"迪丽热巴banner没有LOGO.jpg\"/></p><p>在2018年农历新年来临之际</p><p>火星圈&amp;Dear迪丽热巴后援会相约深圳进行春节探访</p><p>活动现场捐赠了制氧机、助行器、北京老布鞋、手绢套装等急需且贴心的物资和礼物；</p><p>和老人们在一起聊天、活动度过了愉快的时光</p><p>阿达飞奔来送上图片集锦~~</p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173692906635673.jpg\" title=\"6.jpg\" alt=\"6.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173702920452585.jpg\" title=\"1.jpg\" alt=\"1.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173712152970070.jpg\" title=\"2.jpg\" alt=\"2.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173720437853217.jpg\" title=\"3.jpg\" alt=\"3.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173731212434044.jpg\" title=\"4.jpg\" alt=\"4.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173737211482094.jpg\" title=\"5.jpg\" alt=\"5.jpg\"/></p><p><br/></p><p><br/></p><p><br/></p><p style=\"text-align: center;\"><img src=\"http://oss.hxquan.cn/bd/e0-27817539871407219.png\" title=\"可爱.png\" alt=\"可爱.png\"/></p>"
        
        demo1()
    }
    
    private func demo1(){
        //第一种情况 全覆盖 富文本占满整个屏幕
        /// 加载网页
        
        let richTextView = RichTextView(frame: view.bounds, fromVC: self)
        view.addSubview(richTextView)
        richTextView.webHeight = {[unowned self] height in
            self.loadingView .removeFromSuperview()
        }
        
        richTextView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        richTextView.richText = html
        
        //加载loadingView
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    deinit {
        print("RichTextDemo1VC dealloc")
    }
    
}
