//
//  NYSBaseViewController.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSError+NYS.h"

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

/** 状态栏主题样式 */
@property (nonatomic, assign) UIStatusBarStyle customStatusBarStyle;
/** 是否隐藏导航栏 default :NO **/
@property (nonatomic, assign) BOOL isHidenNaviBar;
/** 是否显示返回按钮 default :YES */
@property (nonatomic, assign) BOOL isShowLiftBack;

/// 是否使用系统下拉刷新样式UIRefreshControl     default :YES
@property (nonatomic, assign) BOOL isUseUIRefreshControl;
/// Empty \ Error info
@property (nonatomic, strong) NSError *emptyError;

/** Theme config, allow overridden */
- (void)configTheme;
- (void)setupUI;
- (void)bindViewModel;

/** Default pop back, allow overridden */
- (void)backBtnClicked;

/// Pull down refresh handler
- (void)headerRereshing;
/// Pull up refresh handler
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


#pragma mark - tableview delegate / dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - collectionView delegate / dataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - DZNEmptyDataSetSource
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
