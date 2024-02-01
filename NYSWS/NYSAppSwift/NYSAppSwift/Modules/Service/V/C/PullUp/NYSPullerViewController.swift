//
//  NYSPullerViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/31.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit

class NYSPullerViewController: PullUpController {
    
    @IBOutlet weak var visualEV: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.cornerRadius = NAppRadius
        view.layer.masksToBounds = true
    }

    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: NScreenWidth, height: NScreenHeight - NTopHeight)
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [70 + NBottomHeight, NScreenHeight - pro_headerViewHeight]
    }

    override var pullUpControllerBounceOffset: CGFloat {
        return 20
    }

}

extension NYSPullerViewController {
    
    // 深色模式适配
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBlurEffect()
        }
    }
    
    // 更新 UIBlurEffect
    private func updateBlurEffect() {
        let blurEffect: UIBlurEffect
        if traitCollection.userInterfaceStyle == .dark {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        // 更新 UIVisualEffectView 的效果
        (view.subviews.first as? UIVisualEffectView)?.effect = blurEffect
    }
}
