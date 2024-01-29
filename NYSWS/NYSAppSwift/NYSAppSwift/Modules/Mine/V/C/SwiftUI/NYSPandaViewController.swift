//
//  NYSPandaViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/29.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 14.0, *)
class NYSPandaViewController: NYSRootViewController {
    @StateObject private var fetcher = PandaCollectionFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            // 创建一个 SwiftUI 视图
            let memeCreator = MemeCreator().environmentObject(fetcher).padding(.horizontal)
            
            // 使用 UIHostingController 将 SwiftUI 视图包装到 UIKit 中
            let hostingController = UIHostingController(rootView: memeCreator)
            
            // 添加 UIHostingController 到当前视图控制器的子视图
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            
            // 关闭自动布局约束
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // 添加自定义布局约束
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
}

@available(iOS 14, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        NYSPandaViewController().showPreview()
    }
}
