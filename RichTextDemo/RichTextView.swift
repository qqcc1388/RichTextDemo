//
//  RichTextView.swift
//  hxquan-swift
//
//  Created by Tiny on 2018/11/30.
//  Copyright © 2018年 hxq. All rights reserved.
//  加载富文本内容

import UIKit
import WebKit
import MBProgressHUD

class RichTextView: UIView {

    /// 富文本加载完成后返回高度
    var webHeight: ((_ height: CGFloat)->Void)?
    
    /// 是否允许图片点击弹出
    var isShowImage: Bool = true
    
    /// webView是否可以滚动 默认可以滚动
    var isScrollEnabled: Bool = true{
        didSet{
            webView.scrollView.isScrollEnabled = isScrollEnabled
        }
    }
    
    /// 富文本内容
    var richText: String? {
        didSet{
            if richText == nil {
                richText = ""
            }
            if !isSuccess {
                loadHtml(richText!)
            }
        }
    }
    
    /// 富文本是否加载成功
    private var isSuccess: Bool = false
    
    /// wkwebView 用来加载富文本
    private lazy var webView: WKWebView = { [unowned self] in
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        
        return webView
        }()
    
    /// 富文本中图片数组
    private var imgesArr = [String]()
    
    /// 图片数字标识
    private lazy var indexLabel: HXQLabel = {
        let label = HXQLabel(color:UIColor.white ,font: UIFont.systemFont(ofSize:16))
        return label
    }()
    
    /// 保存按钮
    private lazy var saveBtn: HXQButton = {
        
        let button = HXQButton(title: "保存", color: UIColor.white, font: UIFont.systemFont(ofSize:16)){ [unowned self] btn in
            //点击保存 将图片保存在相册
            if let image = self.browser?.currentImage{
                MBProgressHUD.show()
                image.savedPhotosAlbum(completeBlock: { (success) in
                    MBProgressHUD.hide()
                    if success{
                        MBProgressHUD.showSuccess("保存成功")
                    }else{
                        MBProgressHUD.showError("保存失败")
                    }
                })
            }
        }
        return button
    }()
    
    /// 图片浏览器 这里一定要weak,要不然控制器无法释放
    private weak var browser: GKPhotoBrowser?
    
    /// 图片显示在那个控制器上
    private weak var currentVc: UIViewController?
    
    convenience init(frame: CGRect, fromVC photoBrwoserVc: UIViewController? = nil) {
        self.init(frame: frame)
        currentVc = photoBrwoserVc
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI(){
        
        //设置约束
        addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func loadHtml(_ html: String) {
        let htmlContent = """
        <html>
        <head>
        <meta charset='utf-8' name='viewport' content='width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no'/>
        <style type=\"text/css\">
        img {
        max-width:100%;
        -webkit-tap-highlight-color:rgba(0,0,0,0);
        }
        </style>
        <script type=\"text/javascript\">
        </script>
        </head>
        <body>
        <div>
        <div id=\"webview_content_wrapper\">\(html)</div>
        </div>
        </body>
        </html>
        """
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

extension RichTextView: WKUIDelegate,WKNavigationDelegate{
    
    /// 加载成功
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        /// 获取网页高度
        webView.evaluateJavaScript("document.body.offsetHeight") {[unowned self] (result, _) in
            
            //计算高度
            if let webHeight = result as! CGFloat?{
                self.webView.snp.updateConstraints({ (make) in
                    make.height.equalTo(webHeight)
                })
                self.webHeight?(webHeight)
            }else{
                self.webHeight?(0)
            }
        }
        
        /// 插入JS代码
        if isShowImage {
            insetJsToHtml()
        }
    }
    
    /// 加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webHeight?(0)
    }
    
    /// 拦截
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let str = navigationAction.request.url?.absoluteString.removingPercentEncoding {
            if str.hasPrefix("hxqimage-preview"){  // 点击了图片
                
                //加载图片
                if let clickImg = (navigationAction.request.url as NSURL?)?.resourceSpecifier{
                    if isShowImage{
                        handleImageWithName(clickImg)
                    }
                }
                //禁止跳转
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    private func insetJsToHtml(){
        webView.evaluateJavaScript("""
          function imageClickAction(){
            var imgs=document.getElementsByTagName('img');
            var length=imgs.length;
            for(var i=0;i<length;i++){
                img=imgs[i];
                img.onclick=function(){
                    window.location ='hxqimage-preview:'+this.src;
                }
            }
        }
        """, completionHandler: nil)
        
        //触发方法 给所有的图片添加onClick方法
        webView.evaluateJavaScript("imageClickAction();", completionHandler: nil)
        
        //拿到所有img标签对应的图片
        handleImgLabel()
    }
    
    private func handleImgLabel(){
        
        //要拿到所有img标签对应的图片的src
        
        //1.拿到img标签的个数
        webView.evaluateJavaScript("document.getElementsByTagName('img').length") { [unowned self](result, error) in
            
            if let length = result as! Int?{
                self.imgesArr.removeAll()
                for i in 0..<length{
                    let jsStr = "document.getElementsByTagName('img')[\(i)].src"
                    self.webView.evaluateJavaScript(jsStr, completionHandler: { (result, error) in
                        if let img = result as! String?{
                            self.imgesArr.append(img)
                        }
                    })
                }
            }
        }
    }
    
    private func handleImageWithName(_ clickImg: String){
        //触发点击事件  -- >拿到是第几个标签被点击了
        //遍历数组，查询查找当前第几个图被点击了
        var selectIndex: Int = 0
        var photos = [GKPhoto]()
        for (i,imgUrl) in imgesArr.enumerated() {
            if imgUrl == clickImg{
                selectIndex = i
            }
            let photo = GKPhoto()
            photo.url = URL(string: imgUrl)
            photos.append(photo)
        }
        if !photos.isEmpty {
            let browser = GKPhotoBrowser(photos: photos, currentIndex: selectIndex)
            browser.showStyle = .none
            browser.hideStyle = .zoomScale
            browser.loadStyle = .indeterminateMask
            browser.isResumePhotoZoom = true
            browser.isAdaptiveSaveArea = true
            //            browser.isStatusBarShow = true
            browser.delegate = self
            browser.setupCoverViews([self.indexLabel,self.saveBtn]) { [unowned self](photoBrowser, superFrame) in
                self.resetCover(frame: superFrame, index: photoBrowser.currentIndex)
            }
            indexLabel.text = "\(selectIndex+1)/\(imgesArr.count)"
            guard let currentVc = currentVc else{
                return
            }
            browser.show(fromVC: currentVc)
            self.browser = browser
        }
    }
}

extension RichTextView: GKPhotoBrowserDelegate{
    
    func photoBrowser(_ browser: GKPhotoBrowser, scrollEndedIndex index: Int) {
        resetCover(frame: browser.contentView.bounds, index: index)
        indexLabel.text = "\(index+1)/\(imgesArr.count)"
    }
    
    private func resetCover(frame: CGRect, index: Int){
        //设置保存按钮 和 index标签的位置
        indexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(indexLabel)
            make.right.equalTo(-20)
        }
    }
}

