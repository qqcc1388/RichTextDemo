//
//  RichTextHeaderView.swift
//  RichTextDemo
//
//  Created by Tiny on 2018/12/28.
//  Copyright © 2018年 hxq. All rights reserved.
//

import UIKit

class RichTextHeaderView: UIView {

    /// 回调header的高度
    var headerHeight: ((_ height: CGFloat)->Void)?
    
    var html: String?{
        didSet{
            richTextView.richText = html
        }
    }
    
    //MARK:- 屏幕宽高
    private let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
    private weak var currentVc: UIViewController?
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius  = 16
        imgView.layer.masksToBounds = true
        imgView.image = UIImage(named: "defaultavatar")
        return imgView
    }()
    
    lazy var nameLabel: HXQLabel = {
        let nameLabel = HXQLabel(text: "小屁股嘟嘟嘟")
        return nameLabel
    }()
    
    lazy var timeLabel: HXQLabel = {
        let timeLabel = HXQLabel(text: "2017.02.10. 10:20", color: UIColor.lightGray ,font: UIFont.systemFont(ofSize: 11))
        return timeLabel
    }()
    
    lazy var attentionBtn: HXQButton = {
        let button = HXQButton(title: "+ 关注", color: .red){[unowned self] button in
            //关注事件
        }
        button.layer.cornerRadius = 13.5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    lazy var titleLabel: HXQLabel = {
        let label = HXQLabel(text: "爱豆防弹少年团站在此发起“0元启动0218郑号锡生日 爱豆APP开屏应援”活动。", font: UIFont.systemFont(ofSize: 16), lines: 0)
        label.numberOfLines = 0;
        return label
    }()
    
    lazy var richTextView: RichTextView = {
        let richView = RichTextView(frame: .zero, fromVC: currentVc)
        //不让网页滚动
        richView.isScrollEnabled = false
        // 网页加载完成回调网页高度
        richView.webHeight = { [unowned self] height in
            
            // 将高度传递出去 RichText高度+header中其它控件高度
            self.headerHeight?(self.height+height)
        }
        return richView
    }()
    
    /// 点赞按钮
    private lazy var praiseBtn: HXQButton = {
        let button = HXQButton(title: "点赞", color: .red, font: UIFont.systemFont(ofSize: 16)){ btn in
            btn.isSelected = !btn.isSelected
        }
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 18
        button.setImage(UIImage(named: "circle_icon_thumbup_default"), for: .normal)
        button.setImage(UIImage(named: "circle_icon_thumbup_select"), for: .selected)
        return button
    }()
    
    /// 点赞数量
    private lazy var praiseLabel: HXQLabel = {
        let label = HXQLabel(text: "4563人点赞", color: .gray, font: UIFont.systemFont(ofSize: 14))
        return label
    }()
    
    convenience init(frame: CGRect, fromVC currentVc: UIViewController? = nil) {
        self.init()
        self.currentVc = currentVc
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(imgView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(attentionBtn)
        addSubview(titleLabel)
        addSubview(richTextView)
        addSubview(praiseBtn)
        addSubview(praiseLabel)
        
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.top.equalTo(15)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView)
            make.left.equalTo(imgView.snp.right).offset(5)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imgView)
            make.left.equalTo(nameLabel.snp.left)
        }
        attentionBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgView)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 65, height: 27))
        }
        
        let line = HXQView()
        line.backgroundColor = UIColor.lightGray
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(1)
            make.top.equalTo(imgView.snp.bottom).offset(18)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(line.snp.bottom).offset(15)
        }
        titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
        
        richTextView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        praiseBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(richTextView.snp.bottom).offset(32)
            make.size.equalTo(CGSize(width: 93, height: 36))
        }
        
        praiseLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(praiseBtn.snp.bottom).offset(8)
            make.bottom.equalTo(-10)
        }
    }
}
