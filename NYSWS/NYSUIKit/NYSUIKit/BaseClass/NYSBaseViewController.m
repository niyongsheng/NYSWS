//
//  NYSBaseViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseViewController.h"
#import "CMPopTipView.h"
#import "WSScrollLabel.h"
#import "PublicHeader.h"
#import "LEETheme.h"

#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define NTopHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height

@interface NYSBaseViewController ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end

@implementation NYSBaseViewController

- (void)setCustomStatusBarStyle:(UIStatusBarStyle)StatusBarStyle {
    _customStatusBarStyle = StatusBarStyle;
    // 动态更新状态栏颜色
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置主题
    [self configTheme];
    
    // 默认使用系统刷新样式
    [self setIsUseUIRefreshControl:YES];
    
    // 默认错误信息
//    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:nil];
    self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow description:NSLocalizedStringFromTable(@"NoData", @"InfoPlist", nil) reason:@"" suggestion:NSLocalizedStringFromTable(@"Retry", @"InfoPlist", nil) placeholderImg:@"linkedin_binding_magnifier"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 默认tableview样式，如需要修改建议在子类configTheme方法中重写
    _tableviewStyle = UITableViewStylePlain;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    if (_dataSourceArr.count == 0) {
        self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow description:NSLocalizedStringFromTable(@"NoData", @"InfoPlist", nil) reason:@"" suggestion:NSLocalizedStringFromTable(@"Retry", @"InfoPlist", nil) placeholderImg:@"linkedin_binding_magnifier"];
    }
}

/// 数据源懒加载
- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:_tableviewStyle];
        if (_tableviewStyle == UITableViewStyleGrouped) { // 处理顶部空白高度
            _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, CGFLOAT_MIN)];
        }
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
#ifdef NAppRoundStyle
        _tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
#else
        _tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
#endif

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        NSString *endStr = NSLocalizedStringFromTable(@"NoMore", @"InfoPlist", nil);
        if (self.isUseUIRefreshControl) {
            // header refresh
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = NAppThemeColor;
            [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
            _tableView.refreshControl = refreshControl;
            
            // footer refresh
            MJRefreshAutoNormalFooter *footter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.loadingView.color = NAppThemeColor;
            footter.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
//            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _tableView.mj_footer = footter;
            
        } else {
            
            // 刷新数据的帧动画
            CGSize size = CGSizeMake(35, 35);
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (int i = 1; i <= 7; i++) {
                UIImage *image = [NYSUIKitUtilities imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
                [refreshingImages addObject:[self imageByResizeToSize:size withImage:image]];
            }
            
            // header refresh
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.stateLabel.hidden = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = NO;
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [header setImages:@[[self imageByResizeToSize:size withImage:[NYSUIKitUtilities imageNamed:@"icon_refresh_up"]]] duration:1.0f forState:MJRefreshStatePulling];
            [header setImages:@[UIImage.new, [self imageByResizeToSize:size withImage:[NYSUIKitUtilities imageNamed:@"icon_refresh_dropdown"]]] duration:1.0f forState:MJRefreshStateIdle];
            _tableView.mj_header = header;
            
            // footer refresh
            MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _tableView.mj_footer = footter;
        }
        
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, CGFLOAT_MIN)];
    }
    return _tableView;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) collectionViewLayout:flow];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _collectionView.contentInset = UIEdgeInsetsMake(NTopHeight, 0, 0, 0);
        }
#ifdef NAppRoundStyle
        _collectionView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
#else
        _collectionView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
#endif
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;

        NSString *endStr = NSLocalizedStringFromTable(@"NoMore", @"InfoPlist", nil);
        if (self.isUseUIRefreshControl) {
            // header refresh
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = NAppThemeColor;
            [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
            _collectionView.refreshControl = refreshControl;
            
            // footer refresh
            MJRefreshAutoNormalFooter *footter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//            [footter setAnimationDisabled];
            footter.refreshingTitleHidden = YES;
            footter.loadingView.color = NAppThemeColor;
            footter.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
//            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _collectionView.mj_footer = footter;
            
        } else {
            // 刷新数据的帧动画
            CGSize size = CGSizeMake(35, 35);
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (int i = 1; i <= 7; i++) {
                UIImage *image = [NYSUIKitUtilities imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
                [refreshingImages addObject:[self imageByResizeToSize:size withImage:image]];
            }
            
            // header refresh
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.stateLabel.hidden = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = NO;
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [header setImages:@[[self imageByResizeToSize:size withImage:[NYSUIKitUtilities imageNamed:@"icon_refresh_up"]]] duration:1.0f forState:MJRefreshStatePulling];
            [header setImages:@[UIImage.new, [self imageByResizeToSize:size withImage:[NYSUIKitUtilities imageNamed:@"icon_refresh_dropdown"]]] duration:1.0f forState:MJRefreshStateIdle];
            _collectionView.mj_header = header;
            
            // footer refresh
            MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _collectionView.mj_footer = footter;
        }
        
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}

#pragma mark - MJRefresh Methods
- (void)headerRereshing {
    self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NSLocalizedStringFromTable(@"Loading", @"InfoPlist", nil) reason:@"" suggestion:@"" placeholderImg:@"null"];
}

- (void)footerRereshing {
    self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NSLocalizedStringFromTable(@"Loading", @"InfoPlist", nil) reason:@"" suggestion:@"" placeholderImg:@"null"];
}

#pragma mark - UITableViewDataSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *placeholderStr = self.emptyError.userInfo[@"NSLocalizedPlaceholderImageName"];
    if ([NYSTools stringIsNull:placeholderStr]) {
        return [NYSUIKitUtilities imageNamed:@"error"];
    } else {
        return [NYSUIKitUtilities imageNamed:placeholderStr];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:self.emptyError.localizedDescription attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:self.emptyError.localizedFailureReason ?:@"" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *str = self.emptyError.localizedRecoverySuggestion;
    NSMutableAttributedString *buttonAttStr = [[NSMutableAttributedString alloc] initWithString:str];
    [buttonAttStr addAttribute:NSForegroundColorAttributeName value:NAppThemeColor range:NSMakeRange(0, str.length)];
    [buttonAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, str.length)];
    [buttonAttStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];

    return buttonAttStr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    UIEdgeInsets insets = scrollView.contentInset;
//    return (insets.top == 0.0f) ? -64.0f : 0.0f;
    return 0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    
    NSAssert(_tableView || _collectionView, @"请先实例化页面组件");
    
    if (_tableView) {
        if (self.tableView.refreshControl) {
            [self.tableView.refreshControl beginRefreshing];
        } else if (self.tableView.mj_header) {
            [self.tableView.mj_header beginRefreshing];
        } else if (self.tableView.mj_footer) {
            [self.tableView.mj_footer beginRefreshing];
        } else {
            [NYSTools showBottomToast:@"没有实现TableView刷新方法"];
        }
    } else if (_collectionView) {
        if (self.collectionView.refreshControl) {
            [self.collectionView.refreshControl beginRefreshing];
        } else if (self.collectionView.mj_header) {
            [self.collectionView.mj_header beginRefreshing];
        } else if (self.collectionView.mj_footer) {
            [self.collectionView.mj_footer beginRefreshing];
        } else {
            [NYSTools showBottomToast:@"没有实现CollectionView刷新方法"];
        }
    } else {
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NSLocalizedStringFromTable(@"Loading", @"InfoPlist", nil) reason:@"" suggestion:@"" placeholderImg:@"null"];
    }
}

#pragma mark - seter/getter
- (void)setEmptyError:(NSError *)emptyError {
    _emptyError = emptyError;
    
    if (_tableView) {
        [self.tableView reloadEmptyDataSet];
    } else if (_collectionView) {
        [self.collectionView reloadEmptyDataSet];
    }
}

#pragma mark - 是否显示返回按钮
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack {
    _isShowLiftBack = isShowLiftBack;
    
    NSInteger VCCount = self.navigationController.viewControllers.count;
    // 当VC所在的导航控制器栈中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil || self.tabBarController == nil)) {
        [self addNavigationItemWithImageNames:@[@"back_icon"] isLeft:YES target:self action:@selector(backBtnClicked) tags:@[@"1"]];
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *NULLBar = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (void)backBtnClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark — 导航栏添加图片按钮方法
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标控制器
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    // 调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString *imageName in imageNames) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lee_theme
        .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
            [(UIButton *)item setImage:[NYSUIKitUtilities imageNamed:[imageName stringByAppendingString:@"_day"]] forState:UIControlStateNormal];
        })
        .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
            [(UIButton *)item setImage:[NYSUIKitUtilities imageNamed:[imageName stringByAppendingString:@"_night"]] forState:UIControlStateNormal];
        });
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        } else {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

#pragma mark — 导航栏添加文字按钮方法
/**
 导航栏添加文字按钮

 @param titles 文字数组
 @param isLeft 是否是左边 非左即右
 @param target 目标控制器
 @param action 点击方法
 @param tags tags数组 回调区分用
 @return 文字按钮数组
 */
- (NSMutableArray<UIBarButtonItem *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags {
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    // 调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        btn.lee_theme.LeeConfigButtonTitleColor(@"common_nav_font_color_1", UIControlStateNormal);
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        // 设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        } else {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

/// 修改图片大小
/// - Parameters:
///   - size: 新尺寸
///   - image: 需要修改的图片
- (UIImage *)imageByResizeToSize:(CGSize)size withImage:(UIImage *)image {
    if (size.width <= 0 || size.height <= 0) return nil;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

#pragma mark - 设置主题
- (void)configTheme {
    // 默认显示返回按钮
    self.isShowLiftBack = YES;
    
    // 默认显示状态栏样式
    self.customStatusBarStyle = UIStatusBarStyleDefault;
    
    // 关闭拓展全屏布局，等效于automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.navigationController.navigationBar.translucent = YES;
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
    
    // 导航栏适配
//    if (@available(iOS 13.0, *)) {
//        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
//        barApp.shadowColor = [UIColor clearColor];
//        barApp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5]; // 背景色
//        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
//        self.navigationController.navigationBar.standardAppearance = barApp;
//    }

    // 背景色
    self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_0");
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 支持的旋转方向
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 默认显示方向
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 10.0, *)) {
#ifdef DEBUG
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
#endif
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 控制器销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"dataSource"];];
}

@end
