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
        let model = self.dataSourceArr[indexPath.row] as? NYSHomeList
        cell?.model = model
        
        // 添加上下文菜单交互
        let interaction = UIContextMenuInteraction(delegate: self)
        cell?.addInteraction(interaction)
        
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

extension NYSHomeListViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = self.tableView.indexPathForRow(at: interaction.location(in: interaction.view?.superview)) else {
            return nil
        }
        let model = self.dataSourceArr[indexPath.row] as! NYSHomeList
        
        // 创建上下文菜单配置
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            let contentVC = NYSContentViewController()
            contentVC.titleL.text = model.title
            contentVC.contentL.text = model.content
            contentVC.preferredContentSize = CGSize(width: 300, height: 400)
            return contentVC
            
        }, actionProvider: { _ in
            let action1 = UIAction(title: "Action 1", image: UIImage(systemName: "star.fill")) { _ in
                NYSTools.log("Action 1 selected")
            }
            
            let action2 = UIAction(title: "Action 2", image: UIImage(systemName: "heart.fill")) { _ in
                NYSTools.log("Action 2 selected")
            }
            return UIMenu(title: "Context Menu", children: [action1, action2])
        })
    }
    
}
