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
    
    private func tableHeaderFrameChange() -> Void {
        self.tableView.beginUpdates()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
        self.tableView.endUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        
        weak var weakSelf = self;
        let rc : CGRect = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:0);
        let header : FlexFrameView = FlexFrameView.init(flex: "TableHeader", frame: rc, owner: self)!
        header.flexibleHeight = true
        header.layoutIfNeeded()
        header.onFrameChange = { (rc)->Void in
            weakSelf?.tableHeaderFrameChange()
        }
        self.tableView.frame = CGRectMake(0, 0, NScreenWidth, NScreenHeight - NBottomHeight - RealValueX(x: 80))
        self.tableView.tableHeaderView = header;
        view.addSubview(self.tableView)
        
        // 数据绑定
        vm.refresh.bind(to: self.tableView.rx.refreshAction).disposed(by: bag)
        vm.homeItems.subscribe(onNext: { [weak self] (items: [NYSHomeListModel]) in
            self?.dataSourceArr = NSMutableArray(array: items)
            self?.tableView.reloadData(animationType: .moveSpring)
        }, onError: { (error) in
            print(error)
        }).disposed(by: bag)
    }

    override func headerRereshing() {
        content.text = "This is tableview header " + String.randomString(length: 150)
        vm.fetchHomeDataItemes(headerRefresh: true, params: [:])
    }
    
    override func footerRereshing() {
        vm.fetchHomeDataItemes(headerRefresh: false, params: [:])
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        // 占位偏移量
        return -100;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if _cell == nil {
            _cell = NYSHomeListCell(flex:nil,reuseIdentifier:nil)
        }
        
        _cell.model = self.dataSourceArr[indexPath.row] as? NYSHomeListModel
        return (_cell?.height(forWidth: NScreenWidth))!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier : String = "NYSHomeListCellIdentifier"
        var cell : NYSHomeListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? NYSHomeListCell
        
        if cell == nil {
            cell = NYSHomeListCell(flex:nil, reuseIdentifier:identifier)
        }
        cell?.model = self.dataSourceArr[indexPath.row] as? NYSHomeListModel
        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataSourceArr[indexPath.row] as! NYSHomeListModel
        let vc:NYSRootViewController = NYSRootViewController()
        vc.title = model.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
