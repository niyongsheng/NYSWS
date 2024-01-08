//
//  NYSServiceViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit
import NYSUIKit
import SGPagingView
import ZCycleView
import SnapKit

let pro_headerViewHeight: CGFloat = 270
let pro_pagingTitleViewHeight: CGFloat = 40

let navHeight: CGFloat = 44 + UIScreen.statusBarHeight

class NYSServiceViewController: NYSRootViewController {
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let titles = ["服务一", "服务二", "服务三"]
        let configure = SGPagingTitleViewConfigure()
        configure.showBottomSeparator = false
        configure.indicatorAnimationTime = 0.05
        configure.indicatorType = .Fixed
        configure.indicatorHeight = pro_pagingTitleViewHeight - 10
        configure.indicatorFixedWidth = (UIScreen.width - 150)/CGFloat(titles.count)
        configure.indicatorCornerRadius = 10
        configure.indicatorColor = NAppThemeColor
        configure.indicatorToBottomDistance = 5;
        configure.selectedColor = .white
        configure.color = .darkGray
        
        let frame = CGRect.init(x: 0, y: pro_headerViewHeight, width: view.frame.size.width, height: pro_pagingTitleViewHeight)
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.backgroundColor = .lightText
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    var tempBaseSubVCs: [NYSRootScrollViewController] = []
    lazy var pagingContentView: SGPagingContentScrollView = {
        let vc1 = NYSSubScrollViewController()
        let vc2 = NYSSubScrollViewController()
        let vc3 = NYSSubScrollViewController()
        let vcs = [vc1, vc2, vc3]
        tempBaseSubVCs = vcs
        
        let tempRect: CGRect = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()
    
    var bannerImageArr = ["https://example.com/image.png", "https://example.com/image.png"]
    lazy var headerView: UIView = {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: NScreenWidth, height: pro_headerViewHeight))
        let h = pro_headerViewHeight - NTopHeight
        let cycleView = ZCycleView()
        cycleView.scrollDirection = .horizontal
        cycleView.delegate = self
        cycleView.reloadItemsCount(bannerImageArr.count)
        cycleView.itemZoomScale = 1.2
        cycleView.itemSpacing = 10
        cycleView.initialIndex = 1
        cycleView.isAutomatic = true
        cycleView.isInfinite = true
        cycleView.itemSize = CGSize(width: NScreenWidth, height: h)
        cycleView.frame = CGRect(x: 0, y: NTopHeight, width: NScreenWidth, height: h)
        headerView.addSubview(cycleView)
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "服务"
        
        view.addSubview(UIView())
        view.addSubview(pagingContentView)
        view.addSubview(headerView)
        view.addSubview(pagingTitleView)
        
        tempLastPagingTitleViewY = pro_headerViewHeight
        
        // 监听子视图发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(subTableViewDidScroll), name: NSNotification.Name(NNProSubScrollViewDidScroll), object: nil)
    }
    
    var tempSubScrollView: UIScrollView?
    var tempLastPagingTitleViewY: CGFloat = 0
    var tempLastPoint: CGPoint = .zero
    
}

extension NYSServiceViewController {
    @objc func subTableViewDidScroll(noti: Notification) {
        let scrollingScrollView = noti.userInfo!["scrollingScrollView"] as! UIScrollView
        let offsetDifference: CGFloat = noti.userInfo!["offsetDifference"] as! CGFloat
        
        var distanceY: CGFloat = 0
        
        let baseSubVC = tempBaseSubVCs[pagingTitleView.index]
        
        // 当前滚动的 scrollView 不是当前显示的 scrollView 直接返回
        guard scrollingScrollView == baseSubVC.scrollView else {
            return
        }
        var pagingTitleViewFrame: CGRect = pagingTitleView.frame
        guard pagingTitleViewFrame.origin.y >= navHeight else {
            return
        }
        
        let scrollViewContentOffsetY = scrollingScrollView.contentOffset.y
        
        // 往上滚动
        if offsetDifference > 0 && scrollViewContentOffsetY + pro_subScrollViewContentOffsetY > 0 {
            if (scrollViewContentOffsetY + pro_subScrollViewContentOffsetY + pagingTitleView.frame.origin.y) > pro_headerViewHeight || scrollViewContentOffsetY + pro_subScrollViewContentOffsetY < 0 {
                pagingTitleViewFrame.origin.y += -offsetDifference
                if pagingTitleViewFrame.origin.y <= navHeight {
                    pagingTitleViewFrame.origin.y = navHeight
                }
            }
        } else { // 往下滚动
            if (scrollViewContentOffsetY + pagingTitleView.frame.origin.y + pro_subScrollViewContentOffsetY) < pro_headerViewHeight {
                pagingTitleViewFrame.origin.y = -scrollViewContentOffsetY - pro_pagingTitleViewHeight
                if pagingTitleViewFrame.origin.y >= pro_headerViewHeight {
                    pagingTitleViewFrame.origin.y = pro_headerViewHeight
                }
            }
        }
        
        // 更新 pagingTitleView 的 frame
        pagingTitleView.frame = pagingTitleViewFrame
        
        // 更新 headerView 的 frame
        var headerViewFrame: CGRect = headerView.frame
        headerViewFrame.origin.y = pagingTitleView.frame.origin.y - pro_headerViewHeight
        headerView.frame = headerViewFrame
        
        distanceY = pagingTitleViewFrame.origin.y - tempLastPagingTitleViewY
        tempLastPagingTitleViewY = pagingTitleView.frame.origin.y
        
        // 让其余控制器的 scrollView 跟随当前正在滚动的 scrollView 而滚动
        otherScrollViewFollowingScrollingScrollView(scrollView: scrollingScrollView, distanceY: distanceY)
    }
    
    /// 让其余控制器的 scrollView 跟随当前正在滚动的 scrollView 而滚动
    func otherScrollViewFollowingScrollingScrollView(scrollView: UIScrollView, distanceY: CGFloat) {
        var baseSubVC: NYSRootScrollViewController
        for (index, _) in tempBaseSubVCs.enumerated() {
            baseSubVC = tempBaseSubVCs[index]
            if baseSubVC.scrollView == scrollView {
                continue
            } else {
                if let tempScrollView = baseSubVC.scrollView {
                    var contentOffSet: CGPoint = tempScrollView.contentOffset
                    contentOffSet.y += -distanceY
                    tempScrollView.contentOffset = contentOffSet
                }
            }
        }
    }
}

extension NYSServiceViewController: SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentViewDidScroll() {
        let baseSubVC: NYSRootScrollViewController = tempBaseSubVCs[pagingTitleView.index]
        if let tempScrollView = baseSubVC.scrollView {
            if (tempScrollView.contentSize.height) < UIScreen.main.bounds.size.width {
                tempScrollView.setContentOffset(CGPoint(x: 0, y: -pro_subScrollViewContentOffsetY), animated: false)
            }
        }
    }
}

extension NYSServiceViewController: ZCycleViewProtocol {
    func cycleViewRegisterCellClasses() -> [String: AnyClass] {
        return ["NYSBannerCollectionViewCell": NYSBannerCollectionViewCell.self]
    }

    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NYSBannerCollectionViewCell", for: indexPath) as! NYSBannerCollectionViewCell
        cell.urlStr = bannerImageArr[realIndex]
        return cell
    }
    
    func cycleViewDidScrollToIndex(_ cycleView: ZCycleView, index: Int) {
        
    }
    
    func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int) {
        
    }
    
    func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl) {
        pageControl.isHidden = false
        pageControl.currentPageIndicatorTintColor = NAppThemeColor
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.frame = CGRect(x: 0, y: cycleView.bounds.height-25, width: cycleView.bounds.width, height: 25)
    }
}