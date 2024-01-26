//
//  NYSHomeListViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit
import RxSwift

class NYSHomeListViewController: NYSRootViewController {
    
    var indexStr: String = ""
    
    private let bag = DisposeBag()
    private let vm = NYSHomeViewModel()
    
    private var _cell : NYSHomeListCell!
    @objc private var content : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(self.tableView)
        self.tableView.frame = CGRectMake(0, 0, NScreenWidth, NScreenHeight - NBottomHeight - RealValueX(x: 80))
        
        weak var weakSelf = self;
        let rc : CGRect = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:0);
        let header : FlexFrameView = FlexFrameView.init(flex: "TableHeader", frame: rc, owner: self)!
        self.tableView.tableHeaderView = header;
        header.flexibleHeight = true
        header.layoutIfNeeded()
        header.onFrameChange = { (rc)->Void in
            weakSelf?.tableView.beginUpdates()
            weakSelf?.tableView.tableHeaderView = weakSelf?.tableView.tableHeaderView
            weakSelf?.tableView.endUpdates()
        }
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        vm.homeRefresh.bind(to: self.tableView.rx.refreshAction).disposed(by: bag)
        vm.homeItems.subscribe(onNext: { [weak self] (items: [NYSHomeList]) in
            self?.dataSourceArr = NSMutableArray(array: items)
            self?.tableView.reloadData(animationType: .moveSpring)
        }, onError: { (error) in
            print(error)
        }).disposed(by: bag)
    }

    override func headerRereshing() {
        super.headerRereshing()
        content.text = "This is tableview header " + String.randomString(length: Int.random(in: 1...100))
        vm.fetchHomeDataItemes(headerRefresh: true, parameters: nil)
    }
    
    override func footerRereshing() {
        super.footerRereshing()
        vm.fetchHomeDataItemes(headerRefresh: false, parameters: nil)
    }
}

extension NYSHomeListViewController {

    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        // 占位偏移量
        return -100;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if _cell == nil {
            _cell = NYSHomeListCell(flex:nil,reuseIdentifier:nil)
        }
        
        _cell.model = self.dataSourceArr[indexPath.row] as? NYSHomeList
        return (_cell?.height(forWidth: NScreenWidth))!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier : String = "NYSHomeListCellIdentifier"
        var cell : NYSHomeListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? NYSHomeListCell
        
        if cell == nil {
            cell = NYSHomeListCell(flex:nil, reuseIdentifier:identifier)
        }
        cell?.model = self.dataSourceArr[indexPath.row] as? NYSHomeList
        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataSourceArr[indexPath.row] as! NYSHomeList
        let vc:NYSContentViewController = NYSContentViewController()
        vc.titleL.text = model.title
        vc.contentL.text = model.content
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
