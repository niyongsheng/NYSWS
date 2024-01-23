//
//  NYSServiceViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/15.
//

import UIKit
import NYSKit
import RxSwift
import ExCodable

class NYSServiceViewModel: NYSRootViewModel {
    
    let serviceItems = BehaviorSubject<[NYSService]>(value: [])
    let refresh = PublishSubject<MJRefreshAction>()
    
    /// Mock数据
    func mockServiceData(headerRefresh: Bool, parameters: String) {
        NYSNetRequest.mockRequest(withParameters: parameters,
                                  isCheck: true,
                                  remark: nil,
                                  success: { [weak self] response in
            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: response?["list"] as Any, options: [])
//                let items = try [NYSService].decoded(from: jsonData)
                let items = try [NYSService].decoded(from: response?["list"] as! [Any])
                if headerRefresh {
                    self?.serviceItems.onNext(items)
                    self?.refresh.onNext(.stopRefresh)
                    self?.refresh.onNext(.resetNomoreData)
                } else {
                    if items.count > 0 {
                        let updatedItems = try (self?.serviceItems.value())! + items
                        self?.serviceItems.onNext(updatedItems)
                        self?.refresh.onNext(.stopLoadmore)
                    } else {
                        self?.refresh.onNext(.showNomoreData)
                    }
                }
            } catch {
                self?.serviceItems.onError(error)
                AppAlertManager.shared.showAlert(title: "解码失败：\(error)")
            }
            
        }, failed:{ [weak self] error in
            self?.refresh.onNext(.stopRefresh)
            print("Error: \(String(describing: error))")
        })
    }
    
}
