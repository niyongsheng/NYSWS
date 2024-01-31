//
//  NYSPullerViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/31.
//  Copyright © 2024 niyongsheng. All rights reserved.
//

import UIKit

class NYSPullerViewController: PullUpController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
