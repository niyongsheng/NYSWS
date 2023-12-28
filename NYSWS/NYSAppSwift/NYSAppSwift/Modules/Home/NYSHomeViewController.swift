//
//  NYSHomeViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit
import SGPagingView

class NYSHomeViewController: NYSBaseViewController, SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHidenNaviBar = true;
        
        view.addSubview(searchView)
        view.addSubview(pagingTitleView)
        view.addSubview(pagingContentView)
    }
    
    lazy var searchView: NYSSearchView = {
        let view = NYSSearchView(frame: CGRect(x: NSpaceNormal, y: NStatusBarHeight, width: NScreenWidth - 2 * NSpaceNormal, height: RealValueX(x: 40)))
        view.placeholderText = "搜索起始地/目的地"
        view.delegate = self
        return view
    }()
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.indicatorType = .Dynamic
        configure.gradientEffect = true
        configure.showBottomSeparator = false
        configure.textZoom = true
        configure.textZoomRatio = 0.2
        configure.color = .darkGray
        configure.selectedColor = NAppThemeColor
        configure.indicatorColor = NAppThemeColor
        configure.indicatorToBottomDistance = 0
        
        let frame = CGRect.init(x: 0, y: searchView.bottom + 10, width: UIScreen.width, height: 44)
        let titles = ["待确认", "待装货", "待卸货", "待签收", "已完成"]
        let indexs = ["0", "1", "2", "3", "4"];
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.backgroundColor = .clear
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    lazy var pagingContentView: SGPagingContentCollectionView = {
        let vc0 = NYSHomeListViewController()
        vc0.view.backgroundColor = .orange
        let vc1 = NYSHomeListViewController()
        vc1.view.backgroundColor = .orange
        let vc2 = NYSHomeListViewController()
        vc2.view.backgroundColor = .purple
        let vc3 = NYSHomeListViewController()
        vc3.view.backgroundColor = .green
        let vc4 = NYSHomeListViewController()
        vc4.view.backgroundColor = .brown
        let vcs = [vc0, vc1, vc2, vc3, vc4]
        
        let y: CGFloat = pagingTitleView.frame.maxY
        let tempRect: CGRect = CGRect.init(x: 0, y: y, width: UIScreen.width, height: UIScreen.height - y)
        let pagingContent = SGPagingContentCollectionView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()
    
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
}

extension NYSHomeViewController: NYSSearchViewDelegate {
    func didChangeKeyword(_ keyword: String) {
        
    }
}
