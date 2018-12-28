//
//  RichTextDemo2VC.swift
//  RichTextDemo
//
//  Created by Tiny on 2018/12/28.
//  Copyright © 2018年 hxq. All rights reserved.
//


import UIKit

class RichTextDemo2VC: UIViewController{
    
    private var richTextView: RichTextView!
    
    private var html: String!
    
    private var webHeight: CGFloat = 0
    
    private var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 44;
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        html = "<p><img src=\"http://oss.hxquan.cn/bd/e0-27817083505076241.jpg\" title=\"迪丽热巴banner没有LOGO.jpg\" alt=\"迪丽热巴banner没有LOGO.jpg\"/></p><p>在2018年农历新年来临之际</p><p>火星圈&amp;Dear迪丽热巴后援会相约深圳进行春节探访</p><p>活动现场捐赠了制氧机、助行器、北京老布鞋、手绢套装等急需且贴心的物资和礼物；</p><p>和老人们在一起聊天、活动度过了愉快的时光</p><p>阿达飞奔来送上图片集锦~~</p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173692906635673.jpg\" title=\"6.jpg\" alt=\"6.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173702920452585.jpg\" title=\"1.jpg\" alt=\"1.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173712152970070.jpg\" title=\"2.jpg\" alt=\"2.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173720437853217.jpg\" title=\"3.jpg\" alt=\"3.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173731212434044.jpg\" title=\"4.jpg\" alt=\"4.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173737211482094.jpg\" title=\"5.jpg\" alt=\"5.jpg\"/></p><p><br/></p><p><br/></p><p><br/></p><p style=\"text-align: center;\"><img src=\"http://oss.hxquan.cn/bd/e0-27817539871407219.png\" title=\"可爱.png\" alt=\"可爱.png\"/></p>"
        
        demo2()
    }
    
    private func demo2(){
        
        //第二种情况 富文本作为cell的一部分
        view.addSubview(tableView)
        //设置tableView约束 安全区域
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            }else{
                make.edges.equalToSuperview()
            }
        }
        //由于webView加载需要时间 所以可以在webView加载期间 在界面设置一个loadingView遮挡 当webview加载完无论成功或者失败都会在回调方法中关闭所谓的遮罩，这样可能会给用户一个更好的使用体验
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    deinit {
        print("RichTextDemo2VC dealloc")
    }
}


extension RichTextDemo2VC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            var cell = tableView.dequeueReusableCell(withIdentifier: "customCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "customCell")
                cell?.selectionStyle = .none
                let richTextView = RichTextView(frame: .zero, fromVC: self)
                richTextView.webHeight = { [unowned self] height in
                    self.webHeight = height
                    self.loadingView .removeFromSuperview()
                    self.tableView.reloadData()
                }
                //放在cell中不要让webView滚动
                richTextView.isScrollEnabled = false
                richTextView.richText = html
                cell?.contentView.addSubview(richTextView)
                richTextView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            return cell!
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = "jkdlsfkjsld"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.webHeight
        }
        return UITableView.automaticDimension
    }
    
}

