//
//  ViewController.swift
//  RichTextDemo
//
//  Created by Tiny on 2018/12/28.
//  Copyright © 2018年 hxq. All rights reserved.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

    var richTextView: RichTextView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.title = "RichText 富文本使用demo"
        view.addSubview(tableView)
        //设置tableView约束 安全区域
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            }else{
                make.edges.equalToSuperview()
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        let list = ["Demo1 \n全覆盖 富文本占满整个屏幕",
                    "Demo2 \n富文本作为cell的一部分",
                    "Demo3 \nwebView作为tableView的header并且header中还有其他的控件和业务"
        ]
        //将list转换成controller
        cell?.textLabel?.text = "\(list[indexPath.row])"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcList = ["RichTextDemo1VC","RichTextDemo2VC","RichTextDemo3VC"]
        let vc = stringToController(className: vcList[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 根据字符串转换成类名
    private func stringToController(className: String) -> UIViewController{
        var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String//这是获取项目的名称，
        /**
         * 如果你的工程名字中带有“-” 符号  需要加上 replacingOccurrences(of: "-", with: "_") 这句代码把“-” 替换掉  不然还会报错 要不然系统会自动替换掉 这样就不是你原来的包名了 如果不包含“-”  这句代码 可以不加
         */
        name = name?.replacingOccurrences(of: "-", with: "_")
        let className = name! + "." + className
        guard let controller = NSClassFromString(className) as? UIViewController.Type else{
            fatalError("类名不存在")
        }
        return controller.init()
    }
    
}

