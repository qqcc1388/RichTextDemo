//
//  RichTextDemo3VC.swift
//  RichTextDemo
//
//  Created by Tiny on 2018/12/28.
//  Copyright © 2018年 hxq. All rights reserved.
//

import UIKit

class RichTextDemo3VC: UIViewController{
    
    var html: String!
    
    var webHeight: CGFloat = 0

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
    
    lazy var headerView: RichTextHeaderView = {
        let header = RichTextHeaderView(frame: .zero, fromVC: self)
        header.headerHeight = { [unowned self] height in
            //重新设置headerHeight
            
            self.headerView.height = height
            //注意这里一定要重新设置一次tableHeaderView
            self.tableView.tableHeaderView = self.headerView
            self.loadingView.removeFromSuperview()
        }
        return header
    }()
    
    private var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        //设置UI
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            }else{
                make.edges.equalToSuperview()
            }
        }
        
        tableView.tableHeaderView = self.headerView
        self.headerView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.top.left.right.equalToSuperview()
        })
        self.headerView.layoutIfNeeded()
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let html = "<p><img src=\"http://oss.hxquan.cn/bd/e0-27817083505076241.jpg\" title=\"迪丽热巴banner没有LOGO.jpg\" alt=\"迪丽热巴banner没有LOGO.jpg\"/></p><p>在2018年农历新年来临之际</p><p>火星圈&amp;Dear迪丽热巴后援会相约深圳进行春节探访</p><p>活动现场捐赠了制氧机、助行器、北京老布鞋、手绢套装等急需且贴心的物资和礼物；</p><p>和老人们在一起聊天、活动度过了愉快的时光</p><p>阿达飞奔来送上图片集锦~~</p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173692906635673.jpg\" title=\"6.jpg\" alt=\"6.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173702920452585.jpg\" title=\"1.jpg\" alt=\"1.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173712152970070.jpg\" title=\"2.jpg\" alt=\"2.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173720437853217.jpg\" title=\"3.jpg\" alt=\"3.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173731212434044.jpg\" title=\"4.jpg\" alt=\"4.jpg\"/></p><p><img src=\"http://oss.hxquan.cn/bd/e0-28173737211482094.jpg\" title=\"5.jpg\" alt=\"5.jpg\"/></p><p><br/></p><p><br/></p><p><br/></p><p style=\"text-align: center;\"><img src=\"http://oss.hxquan.cn/bd/e0-27817539871407219.png\" title=\"可爱.png\" alt=\"可爱.png\"/></p>"
        
        headerView.html = html
    }
    
    deinit {
        print("RichTextDemo3VC dealloc")
    }
}

extension RichTextDemo3VC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = "xxx"
        return cell!
    }
}
