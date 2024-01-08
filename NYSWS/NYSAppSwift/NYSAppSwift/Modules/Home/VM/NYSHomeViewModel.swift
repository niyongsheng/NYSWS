//
//  NYSHomeViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import Foundation

class NYSHomeViewModel: NYSRootViewModel {
    
    // 随机生成测试数据
    func generateRandomDataArray(length: Int) -> [ [String: String] ] {
        var dataArray = [[String: String]]()
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        for _ in 0..<length {
            let randomDataEntry = [
                "name": String.randomString(length: 5),
                "type": String.randomString(length: 10),
                "date": formattedDate,
                "title": String.randomString(length: 20),
                "content": String.randomString(length: 200)
            ]
            dataArray.append(randomDataEntry)
        }
        
        return dataArray
    }
    
    func getDataList(success : @escaping (_ data : [NYSHomeListModel]) -> ()) -> Void {
        let randomDataArray = generateRandomDataArray(length: NAppPageSize)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: randomDataArray, options: [])
            let list = try JSONDecoder().decode([NYSHomeListModel].self, from: jsonData)
            success(list)
        } catch {
            print("解码失败：\(error)")
        }
    }
    
}
