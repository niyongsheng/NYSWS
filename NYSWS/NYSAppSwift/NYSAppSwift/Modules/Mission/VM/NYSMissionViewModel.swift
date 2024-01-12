//
//  NYSMissionViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/11.
//

import UIKit
import NYSKit
import RxSwift

class NYSMissionViewModel: NYSRootViewModel {
    
    let weatherSubject = PublishSubject<NYSWeater>()
    let refresh = PublishSubject<MJRefreshAction>()
    
    /// 天气数据加载
    /// - Parameter parameters: 参数
    /// - Parameter headerRefresh: 是否头部刷新
    func fetchWeatherData(headerRefresh: Bool, parameters: [String: Any]?) {
        NYSNetRequest.jsonNoCheckNetworkRequest(
            with: NYSNetRequestType(GET.rawValue),
            url: Api_Weather_Url,
            parameters: parameters,
            remark: "天气数据",
            success: { [weak self] response in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response as Any, options: [])
                    let weather = try JSONDecoder().decode(NYSWeater.self, from: jsonData)
                    self?.weatherSubject.onNext(weather)
                } catch {
                    print("Error: \(error)")
                    self?.weatherSubject.onError(error)
                }
                self?.refresh.onNext(.stopRefresh)
                
            }, failed:{ [weak self] error in
                self?.refresh.onNext(.stopRefresh)
                print("Error: \(String(describing: error))")
            })
    }
    
    
}
