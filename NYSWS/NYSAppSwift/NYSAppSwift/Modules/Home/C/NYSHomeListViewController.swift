//
//  NYSHomeListViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit

class NYSHomeListViewController: NYSRootViewController {
    
    var indexStr: String = ""
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
    }

    override func headerRereshing() {
        content.text = "This is tableview header " + String.randomString(length: 150)

        NYSHomeViewModel().getDataList(success: { [weak self] data in
            self?.dataSourceArr = NSMutableArray(array: data)
            self?.tableView.reloadData(animationType: .moveSpring)
            self?.tableView.refreshControl?.endRefreshing()
        })
    }
    
    override func footerRereshing() {
        NYSHomeViewModel().getDataList(success: { [weak self] data in
            if data.count == 0 {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                
                self?.dataSourceArr.addObjects(from: data)
                self?.tableView.reloadData()
                self?.tableView.mj_footer?.endRefreshing()
            }
        })
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
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
