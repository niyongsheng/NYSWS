//
//  NYSHomeViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import Foundation
import RxSwift

class NYSHomeViewModel: NYSRootViewModel {

    let homeItems = BehaviorSubject<[NYSHomeListModel]>(value: [])
    
    let refresh = PublishSubject<MJRefreshAction>()
    
    /// RxSwift方式数据加载
    /// - Parameter parameters: 参数
    /// - Parameter headerRefresh: 是否头部刷新
    func fetchHomeDataItemes(headerRefresh: Bool, parameters: [String: Any]?) {
        let randomDataArray = generateRandomDataArray(length: NAppPageSize)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: randomDataArray, options: [])
            let items = try JSONDecoder().decode([NYSHomeListModel].self, from: jsonData)
            if headerRefresh {
                homeItems.onNext(items)
                refresh.onNext(.stopRefresh)
                refresh.onNext(.resetNomoreData)
            } else {
                if items.count > 0 {
                    let updatedItems = try homeItems.value() + items
                    homeItems.onNext(updatedItems)
                    refresh.onNext(.stopLoadmore)
                } else {
                    refresh.onNext(.showNomoreData)
                }
            }
        } catch {
            homeItems.onError(error)
            AppManager.shared.showAlert(title: "解码失败：\(error)")
        }
    }
    
    /// 闭包方式数据加载
    /// - Parameters:
    ///   - parameters: 参数
    ///   - success: 回调
    /// - Returns: 返回
    func fetchHomeDataItemes(parameters: [String: Any]?, success : @escaping (_ data : [NYSHomeListModel]) -> ()) -> Void {
        let randomDataArray = generateRandomDataArray(length: NAppPageSize)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: randomDataArray, options: [])
            let items = try JSONDecoder().decode([NYSHomeListModel].self, from: jsonData)
            success(items)
        } catch {
            print("解码失败：\(error)")
        }
    }
    
}

extension NYSHomeViewModel {
    
    /// 随机生成测试数据
    /// - Parameter length: 数据长度
    /// - Returns: 测试数据
    private func generateRandomDataArray(length: Int) -> [ [String: String] ] {
        var dataArray = [[String: String]]()
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let letters = "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
        for _ in 0..<length {
            let randomDataEntry = [
                "name": String.randomString(length: 5),
                "type": String.randomString(letters: letters, length: 10),
                "date": formattedDate,
                "title": String.randomString(length: 20),
                "content": String.randomString(letters: letters, length: Int.random(in: 1...1024))
            ]
            dataArray.append(randomDataEntry)
        }
        return dataArray
    }
}
