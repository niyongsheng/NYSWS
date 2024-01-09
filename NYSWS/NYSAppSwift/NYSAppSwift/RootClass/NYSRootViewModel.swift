//
//  NYSRootViewModel.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import Foundation
import RxSwift
import Alamofire

class NYSRootViewModel {
    /// inputs修饰前缀
    var inputs: Self { self }

    /// outputs修饰前缀
    var outputs: Self { self }
    
    /// 网络请求错误
    let networkError = PublishSubject<NSError?>()
    
    /// 模型名称
    var className: String { String(describing: self) }
    
    deinit {
        print("\(classNameWithoutNamespace)被销毁了")
    }
}

extension NYSRootViewModel: TypeNameProtocol {}

extension NYSRootViewModel {
    
    /// - Parameter event: SingleEvent
    func processRxRequestEvent(event: SingleEvent<some Codable>) {
        networkError.onNext(event.netError)
    }}

extension SingleEvent {
    var netError: NSError? {
        switch self {
        case .success(_):
            return nil
        case .failure(let error):
            guard let netError = error as? NSError else {
                return NSError(domain: "未知错误", code: -1, userInfo: nil)
            }
            
            return netError
        }
    }
}
