//
//  NYSBaseViewController.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSError+NYS.h"
#import "UITableView+XSAnimationKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYSBaseViewController : UIViewController
{
    /// tabview style. default:UITableViewStylePlain
    UITableViewStyle _tableviewStyle;
}

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

/** 状态栏样式 */
@property (nonatomic, assign) UIStatusBarStyle customStatusBarStyle;
/** 是否隐藏导航栏 default :NO **/
@property (nonatomic, assign) BOOL isHidenNaviBar;
/** 是否显示返回按钮 default :YES */
@property (nonatomic, assign) BOOL isShowLiftBack;

/// 是否使用系统下拉刷新样式UIRefreshControl     default :YES
@property (nonatomic, assign) BOOL isUseUIRefreshControl;
/// empty view error info
@property (nonatomic, strong) NSError *emptyError;

#pragma mark - 设置主题
- (void)configTheme;

/** 默认返回按钮的点击事件，默认是返回，子类可重写 */
- (void)backBtnClicked;

/// pull down refresh handler
- (void)headerRereshing;
/// pull up refresh handler
- (void)footerRereshing;

/**
 导航栏添加文字按钮
 
 @param titles 文字数组
 @param isLeft 是否是左边 非左即右
 @param target 目标控制器
 @param action 点击方法
 @param tags tags数组 回调区分用
 @return 文字按钮数组
 */
- (NSMutableArray<UIBarButtonItem *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags;

/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
