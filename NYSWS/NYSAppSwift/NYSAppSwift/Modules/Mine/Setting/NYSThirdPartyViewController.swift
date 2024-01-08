//
//  NYSThirdPartyViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/6.
//

import UIKit
import AcknowList

class NYSThirdPartyViewController: NYSRootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        self.navigationItem.title = AcknowLocalization.localizedTitle()
        
        self.tableView.refreshControl = nil
        self.tableView.mj_footer = nil
        self.view.addSubview(self.tableView)
        
        let list = AcknowParser.defaultAcknowList()?.acknowledgements ?? []
        self.dataSourceArr.addObjects(from: list)
        self.tableView.reloadData()
        TableViewAnimationKit.show(with: .alpha, tableView: self.tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let acknowledgement = self.dataSourceArr[indexPath.row] as! Acknow
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = acknowledgement.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NYSThirdPartyDetailViewController(acknowledgement: self.dataSourceArr[indexPath.row] as! Acknow)
        navigationController?.pushViewController(vc, animated: true)
    }
}
