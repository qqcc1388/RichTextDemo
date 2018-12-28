项目中很多地方都会用到富文本的内容：比如一般的商品详情，视频详情，资讯详情等，运营人员通过后台的富文本编辑器编辑的内容，前端拿到的就是一段富文本的字符串，这富文本大多都是图片和文字的组合。我们今天介绍的RichTextView就是一个用来加载富文本的视图

富文本要显示出来可以使用NSAttributedString来加载通过label或者textView来显示出来，如果只是纯文字的话，直接用label和textView显示出来当然没什么问题，可是如果有图片就很麻烦了，由于是网络图片，要将图片和文字布局起来几乎很难做到

RichTextView采用的是WebView的方式来加载富文本，将富文本当做一段html代码来加载，这样，当所有在富文本编辑器里面的css，在webview中都可以生效  

我们也知道，网页加载内容的时候，如果webView覆盖整个controller的view，可以直接设置webView的宽高和view的宽高相同，但是如果富文本的网页只是界面内容的一部分，可以是tableView的tableheaderView或者可以是tableView的某一个cell,那么我们就不得不面临一个问题，需要在内容加载完成之后将webView的高度回调回来，同时还要保证webView不会重复被加载

如果webView中有图片，那么可以通过JavaScript注入标签的方式，将图片的url找出来，然后通过你想要展示的方式展示出来，我这里使用的是GKPhotoBrowser这个图片浏览器展示的

RichTextView可以完全解决上面的几个问题

demo示例图片
<div style="text-align:left">
<img src="https://img2018.cnblogs.com/blog/950551/201812/950551-20181228170412554-1234245075.png" width="25%" height="25%"><img src="https://img2018.cnblogs.com/blog/950551/201812/950551-20181228170425983-1576131253.png" width="25%" height="25%"><img src="https://img2018.cnblogs.com/blog/950551/201812/950551-20181228170437325-2046606355.png" width="25%" height="25%"><img src="https://img2018.cnblogs.com/blog/950551/201812/950551-20181228170447358-374075847.png" width="25%" height="25%">
</div>

RichTextView可以很轻松解决下面问题：
- 加载富文本字符串
- 支持富文本中图片点击（js注入标签）
- 加载完成返回高度
- 图片点击放大，并能保存图片到相册
- 提供富文本作为普通视图，TableView的TableHeaderView， TableView的Cell示例
```
    /// 富文本加载完成后返回高度
    var webHeight: ((_ height: CGFloat)->Void)?

    /// 是否允许图片点击弹出
    var isShowImage: Bool = true

    /// webView是否可以滚动 默认可以滚动  根据情况设置
    var isScrollEnabled: Bool = true
    
    /// 富文本内容
   var richText: String? 
```
关于富文本中怎么通过JS注入标签实现图片点击并放大的功能的请参考我的往期文章： https://www.cnblogs.com/qqcc1388/p/6962895.html

下面通过3个实际的应用场景来诠释RichTextView的用法 代码全部使用swift4.0编写 布局使用snapKit 图片显示采用GKPhotoBrowser 弹窗使用MBProgressHUD

###场景1： 全覆盖 富文本占满整个屏幕
这种情况下设置富文本的宽高同controller的view的宽高一致，这样有一个好处就是不用太关心富文本的高度是多少了反正可以铺满整个屏幕
一些注意点我归纳总结一下：
- 让RichText isScrollEnabled设置为true 这样能够保证RichText能够在整个屏幕滚动
- WebView加载富文本需要时间并不是瞬间就可以加载完成，所以当开始加载的时候可以设置一个loadingView作为遮罩，当加载完成之后移除遮罩，这样可以提升用户体验
代码部分：
```
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

```

###场景2： 富文本作为TableView的cell
把RichText作为TableViewcell的一部分，RichText做了处理防止TableView滚动过程中webView自动load,RichText会在webView加载完成后将RichText高度回调出来，将高度缓存起来，这样就不用担心cell来回刷新导致性能不行的问题了
一些注意点我归纳总结一下：
- 让RichText isScrollEnabled设置为false 这样防止cell滚动过程中RichText还在滚动导致异常卡顿的情况
- 将RichText回调的高度缓存起来
- 注意不要造成循环引用
- WebView加载富文本需要时间并不是瞬间就可以加载完成，所以当开始加载的时候可以设置一个loadingView作为遮罩，当加载完成之后移除遮罩，这样可以提升用户体验

代码部分：
```

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


```
###场景2： 富文本作为TableView的tableheaderView的一部分
将富文本作为TableViewHeaderView的一部分，这种场景的使用频率特别高，典型的像今日头条资讯详情部分，像一般商场app商品详情部分大都是在TableView的TableHeaderView中嵌套webView
一些注意点我归纳总结一下：
- RichText加载完成后需要重试header的高度，并且重设``self.tableView.tableHeaderView = self.headerView``
- 设置TableView的header高度部分我这里用的是利用约束自适应高度，如果你也是这种方法设置的，请注意设置完约束后一定要调用一次``self.headerView.layoutIfNeeded()``方法让高度生效
- RichText嵌入到Header中，RichText原本高度默认设置为0，只有当RichText加载ok才会通过约束设置RichText的真实高度，header传递出去的高度应该是RichText的高度+header中其它控件的高度
- 让RichText isScrollEnabled设置为false 防止多重滚动的问题

```
        richView.webHeight = { [unowned self] height in
            
            // 将高度传递出去 RichText高度+header中其它控件高度
            self.headerHeight?(self.height+height)
        }
```
- RichText本身带有防止webview重复加载的，所以不用担心性能问题
- WebView加载富文本需要时间并不是瞬间就可以加载完成，所以当开始加载的时候可以设置一个loadingView作为遮罩，当加载完成之后移除遮罩，这样可以提升用户体验

代码部分：
```
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

```
