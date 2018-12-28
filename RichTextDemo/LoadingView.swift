//
//  LoadingView.swift
//  RichTextDemo
//
//  Created by Tiny on 2018/12/28.
//  Copyright © 2018年 hxq. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    lazy var label: HXQLabel = {
        let label = HXQLabel(text: "别着急，正在加载中...", color: UIColor.gray)
        return label
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI(){
        backgroundColor = .white
        
        addSubview(label)
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(indicatorView.snp.bottom).offset(20)
        }
        
        indicatorView.startAnimating()
    }

}
