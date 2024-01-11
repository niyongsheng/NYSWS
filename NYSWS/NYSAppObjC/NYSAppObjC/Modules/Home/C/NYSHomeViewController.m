//
//  NYSHomeViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/28.
//

#import "NYSHomeViewController.h"
#import "NYSHomeModel.h"
#import "NYSBannerCell.h"
#import "NYSBusinessView.h"
#import "NYSRecommendedCell.h"
#import "PopTableListView.h"

#import "NYSSearchCourseVC.h"
#import "NYSCatalogSearchViewController.h"
#import "NYSHomeCourseVC.h"

#import "NYSCallCenterVC.h"
#import "NYSRecommendVC.h"
#import "NYSMessageCenterVC.h"

#import "NYSCourseDetailVC.h"
#import "NYSPurchasedCourseDetailVC.h"

#import "ThirdViewController.h"

#define HomeBannerHeight        RealValue(180)
#define HomeRecommendedHeight   RealValue(150)

@interface NYSHomeViewController ()
<
PopTableCellDelegate,
UIScrollViewDelegate,
SGPagingTitleViewDelegate,
SGPagingContentViewDelegate,
NYSBusinessViewDelegate,
NYSHomeCourseVCDelegate
>
@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UIView *bannerContainerView;

@property (nonatomic, strong) WMZBannerParam *bannerParam;
@property (nonatomic, strong) WMZBannerParam *recommendedParam;

@property (nonatomic, strong) WMZBannerView *bannerView;
@property (nonatomic, strong) WMZBannerView *recommendedView;

@property (nonatomic, strong) UITextField *searchTF;


@property (nonatomic, strong) NYSHomeModel *homeModel;
/// 轮播图
@property (nonatomic, strong) NSMutableArray<NYSBannerModel *> *bannerArray;
/// 菜单栏
@property (nonatomic, strong) NSMutableArray<NYSBusinessModel *> *businessArray;
/// 推荐课程
@property (nonatomic, strong) NSMutableArray<NYSHomeCourseModel *> *recommendedArray;

@property (nonatomic, strong) SGPagingTitleView *pageTitleView;
@property (nonatomic, strong) SGPagingContentCollectionView *pageContentCollectionView;

@property (nonatomic, strong) PopView *popView;
@property (nonatomic, strong) PopTableListView *popListView;

@property (nonatomic, strong) NSMutableArray *childVCs;
@end

@implementation NYSHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    NAppManager.isLogined ? [NAppManager loadUserInfoCompletion:nil] : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"CFBundleDisplayName");
    [self setupNav];
    
    // 刷新课程数据
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NNotificationReloadData" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if (self->_bannerContainerView) {
            [self headerRereshing];
        } else {
            [self getPagingData];
        }
    }];
    
    // 刷新token后加载数据，绘制页面
    if (NAppManager.isLogined) {
        [NYSNetRequest jsonNetworkRequestWithType:POST
                                                url:@"/index/Member/refresh"
                                           parameters:nil
                                             remark:@"刷新Token"
                                            success:^(id response) {
            @strongify(self)
            if ([response isNotBlank]) {
                [NUserDefaults setValue:response forKey:NUserTokenKey];
                [NUserDefaults synchronize];
                NAppManager.token = nil;
                [[NYSKitManager sharedNYSKitManager] setToken:NAppManager.token];
                
                [self getPagingData];
                
                // 更新缓存
                if (NAppManager.isLogined) {
                    [NAppManager cacheAudioData:YES isRecache:YES];
                }
            }
        } failed:^(NSError * _Nullable error) {
            @strongify(self)
            [self getPagingData];
        }];
        
    } else {
        [self getPagingData];
    }
}

- (void)headerRereshing {
    [self getData];
    [self.pageTitleView resetWithIndex:0];
    [NNotificationCenter postNotificationName:@"HomeRefreshNotification" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.containerScrollView.refreshControl endRefreshing];
    });
}

- (void)getPagingData {
    NSMutableArray *valueArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    [valueArr addObject:@""];
    [titleArr addObject:NSLocalizedStringFromTable(@"All", @"InfoPlist", nil)];
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Courseclass/list"
                                       parameters:nil
                                         remark:@"课程分类"
                                        success:^(id response) {
        @strongify(self)
        [NUserDefaults setValue:response forKey:@"Course_Class_List"];
        [NUserDefaults synchronize];
        for (NSDictionary *dict in response) {
            [valueArr addObject:dict[@"id"]];
            [titleArr addObject:dict[@"name"]];
        }
        [self setupUI:titleArr valueArr:valueArr];
        [self getData];
        
    } failed:^(NSError * _Nullable error) {
        @strongify(self)
        id response = [NUserDefaults valueForKey:@"Course_Class_List"];
        if (response) {
            for (NSDictionary *dict in response) {
                [valueArr addObject:dict[@"id"]];
                [titleArr addObject:dict[@"name"]];
            }
            [self setupUI:titleArr valueArr:valueArr];
            [self getData];
        }
    }];
}

- (void)getData {
    @weakify(self)
    
    // 轮播图
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Index/banner"
                                       parameters:@{ @"page": @1, @"limit": @999 }
                                         remark:@"轮播图"
                                        success:^(id response) {
        @strongify(self)
        self.bannerArray = [NSArray modelArrayWithClass:[NYSBannerModel class] json:response].mutableCopy;
        self.bannerParam.wDataSet(self.bannerArray);
        [self.bannerView updateUI];
    } failed:^(NSError * _Nullable error) {
        
    }];
    
    // 推荐课程
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Course/recommend_list"
                                       parameters:@{ @"page": @1, @"limit": @999 }
                                         remark:@"推荐课程"
                                        success:^(id response) {
        @strongify(self)
        CGFloat h = self.bannerContainerView.bottom + HomeRecommendedHeight + 2 * NNormalSpace;
        self.recommendedArray = [NSArray modelArrayWithClass:[NYSHomeCourseModel class] json:response].mutableCopy;
        if (self.recommendedArray.count == 0) {
            self.recommendedView.height = 0;
            self.recommendedView.hidden = YES;
            
            h = self.bannerContainerView.bottom + NNormalSpace;
        } else {
            self.recommendedView.height = HomeRecommendedHeight;
            self.recommendedView.hidden = NO;
        }
        self.pageTitleView.top = h;
        self.pageContentCollectionView.top = h + 44;
        
        self.recommendedParam.wDataSet(self.recommendedArray);
        [self.recommendedView updateUI];
    } failed:^(NSError * _Nullable error) {
        
    }];
}

- (PopTableListView *)popListView{
    if (_popListView == nil) {
        _popListView = [[PopTableListView alloc] initWithTitles:@[@"简体中文",@"ກະຣຸນາ"] imgNames:nil];
        _popListView.backgroundColor = [UIColor whiteColor];
        _popListView.layer.cornerRadius = 15;
        _popListView.delegate = self;
    }
    return _popListView;
}

#pragma mark - PopTableCellDelegate
- (void)cellOnclick:(NSIndexPath *)indexPath tag:(NSInteger)tag {
    [PopView hidenPopView];
    
    if (indexPath.row == 0) {
        [self showHUDCompletion:^{
            [NYSUIKitUtilities setUserLanguage:@"zh-Hans"];
            NRootViewController = [NYSTabbarViewController new];
        }];
        
    } else {
        [self showHUDCompletion:^{
            [NYSUIKitUtilities setUserLanguage:@"lo-LA"];
            NRootViewController = [NYSTabbarViewController new];
        }];
    }
    
    //    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    UIWindow *window = app.window;
    //    [UIView animateWithDuration:1.5f animations:^{
    //        window.alpha = 0.15;
    //    } completion:^(BOOL finished) {
    //        exit(0);
    //    }];
}

- (void)showHUDCompletion:(void (^ __nullable)(void))completion {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].delegate.window.rootViewController = [[NYSTabbarViewController alloc] init];
        [vc dismissViewControllerAnimated:NO completion:completion ?: nil];
    });
}

- (void)rightBtnOnclicked:(UIButton *)sender {
    self.popView = [PopView popUpContentView:self.popListView direct:PopViewDirection_PopUpBottom onView:sender offset:0 triangleView:nil animation:YES];
    self.popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

#pragma mark - UI布局
- (void)setupNav {
    NYSIconLeftButton *rightBtn = [NYSIconLeftButton buttonWithType:UIButtonTypeCustom];
    CGFloat w = 60;
    CGFloat iconW = 15;
    [rightBtn setTitleRect:CGRectMake(0, 0, w - iconW, iconW)];
    [rightBtn setImageRect:CGRectMake(w - iconW, 0, iconW, iconW)];
    rightBtn.frame = CGRectMake(0, 0, w, iconW);
    [rightBtn setImage:[UIImage imageNamed:@"detail_ico_more"] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeCenter;
    [rightBtn setTitle:NLocalizedStr(@"Language") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupUI:(NSMutableArray *)titleArr valueArr:(NSMutableArray *)valueArr {
    [self.view removeAllSubviews];
    
    CGFloat h = 0;
    
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.containerScrollView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = NAppThemeColor;
    [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
    self.containerScrollView.refreshControl = refreshControl;
    [self.view addSubview:self.containerScrollView];
    
    self.bannerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HomeBannerHeight + 500)];
    _bannerContainerView.backgroundColor = UIColor.whiteColor;
    [self.containerScrollView addSubview:self.bannerContainerView];
    
    // 轮播图
    self.bannerView = [[WMZBannerView alloc] initConfigureWithModel:self.bannerParam withView:self.bannerContainerView];
    self.bannerView.top = NNormalSpace;
    self.bannerView.centerX = self.bannerContainerView.centerX;
    h = HomeBannerHeight + 2 * NNormalSpace;
    
    // 菜单图
    CGFloat businessW = (kScreenWidth - 2 * NNormalSpace) / 4;
    for (int i = 0; i < self.businessArray.count; i ++) {
        NYSBusinessModel *businessModel = self.businessArray[i];
        NYSBusinessView *cell = [[NYSBusinessView alloc] initWithFrame:CGRectMake(NNormalSpace + i * businessW, h, businessW, businessW)];
        cell.delegate = self;
        cell.businessModel = businessModel;
        [self.bannerContainerView addSubview:cell];
    }
    h += (businessW + NNormalSpace);
    
    // 搜索框
    CGFloat searchViewH = 40;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, h, kScreenWidth - 2 * NNormalSpace, searchViewH)];
    ViewRadius(searchView, searchViewH/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.bannerContainerView addSubview:searchView];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, searchViewH/4, searchViewH/2, searchViewH/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, searchViewH)];
    self.searchTF.userInteractionEnabled = NO;
    self.searchTF.placeholder = NLocalizedStr(@"Search");
    [searchView addSubview:self.searchTF];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2 * NNormalSpace, searchViewH)];
    [searchBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //        NYSSearchCourseVC *searchVC = [NYSSearchCourseVC new];
        //        searchVC.type = @"1";
        //        [self.navigationController pushViewController:searchVC animated:YES];
        
        NYSCatalogSearchViewController *vc = NYSCatalogSearchViewController.new;
        vc.isHomeSearch = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [searchView addSubview:searchBtn];
    
    // 修正高度
    self.bannerContainerView.height = searchView.bottom + NNormalSpace;
    [self.bannerContainerView layoutIfNeeded];
    
    // 推荐课程
    self.recommendedView = [[WMZBannerView alloc] initConfigureWithModel:self.recommendedParam withView:self.containerScrollView];
    self.recommendedView.top = self.bannerContainerView.bottom + NNormalSpace;
    self.recommendedView.left = 0;
    h = self.bannerContainerView.bottom + HomeRecommendedHeight + 2 * NNormalSpace;
    
    // 分页栏
    //    NSArray *titleArr = @[NSLocalizedStringFromTable(@"All", @"InfoPlist", nil),
    //                          NSLocalizedStringFromTable(@"Laos", @"InfoPlist", nil),
    //                          NSLocalizedStringFromTable(@"Chinese", @"InfoPlist", nil),
    //                          NSLocalizedStringFromTable(@"English", @"InfoPlist", nil)];
    //    NSArray *valueArr = @[@"0", @"1", @"2", @"3"];
    SGPagingTitleViewConfigure *segmentConfigure = [[SGPagingTitleViewConfigure alloc] init];
    segmentConfigure.indicatorType = IndicatorTypeDefault;
    segmentConfigure.indicatorColor = NAppThemeColor;
    segmentConfigure.showBottomSeparator = NO;
    segmentConfigure.indicatorHeight = 4;
    segmentConfigure.indicatorCornerRadius = 2;
    segmentConfigure.indicatorScrollStyle = IndicatorScrollStyleDefault;
    segmentConfigure.font = [UIFont boldSystemFontOfSize:15.0];
    segmentConfigure.textZoom = YES;
    segmentConfigure.textZoomRatio = .4f;
    segmentConfigure.indicatorToBottomDistance = 4;
    
    self.pageTitleView = [[SGPagingTitleView alloc] initWithFrame:CGRectMake(NNormalSpace, h, kScreenWidth * 0.75, 44) titles:titleArr configure:segmentConfigure];
    _pageTitleView.delegate = self;
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    self.pageTitleView
        .lee_theme.LeeAddCustomConfig(DAY, ^(SGPagingTitleView *item) {
            [item resetTitleWithColor:[UIColor blackColor] selectedColor:NAppThemeColor];
        }).LeeAddCustomConfig(NIGHT, ^(SGPagingTitleView *item) {
            [item resetTitleWithColor:[UIColor lightGrayColor] selectedColor:NAppThemeColor];
        });
    [self.containerScrollView addSubview:_pageTitleView];
    
    self.childVCs = [NSMutableArray array];
    for (NSString *valueStr in valueArr) {
        NYSHomeCourseVC *hVC = [[NYSHomeCourseVC alloc] init];
        hVC.delegate = self;
        hVC.index = valueStr;
        [self.childVCs addObject:hVC];
    }
    self.pageContentCollectionView = [[SGPagingContentCollectionView alloc] initWithFrame:CGRectMake(0, h+44, kScreenWidth, 100000) parentVC:self childVCs:self.childVCs];
    self.pageContentCollectionView.delegate = self;
    [self.containerScrollView addSubview:_pageContentCollectionView];
    
    // 可滚动范围
    self.containerScrollView.contentSize = CGSizeMake(0, self.pageContentCollectionView.bottom + NNormalSpace);
}

#pragma mark - SGPagingTitleViewDelegate
- (void)pagingTitleViewWithTitleView:(SGPagingTitleView *)titleView index:(NSInteger)index {
    [self.pageContentCollectionView setPagingContentViewWithIndex:index];
    
    NYSHomeCourseVC *hVC = self.childVCs[index];
    [self tableviewHeight:hVC.tableViewHeight];
}

#pragma mark - SGPagingContentViewDelegate
- (void)pagingContentViewWithContentView:(SGPagingContentView *)contentView progress:(CGFloat)progress currentIndex:(NSInteger)currentIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPagingTitleViewWithProgress:progress currentIndex:currentIndex targetIndex:targetIndex];
    
    if (progress == 1) {
        NYSHomeCourseVC *hVC = self.childVCs[targetIndex];
        [self tableviewHeight:hVC.tableViewHeight];
    }
}

#pragma mark - NYSHomeCourseVCDelegate
- (void)tableviewHeight:(CGFloat)height {
    CGFloat h = self.pageTitleView.bottom + height + NNormalSpace;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.containerScrollView.contentSize = CGSizeMake(0, h);
    }];
}

#pragma mark - NYSBusinessViewDelegate
- (void)tapViewWithModel:(NYSBusinessModel *)model {
    if ([model.title isEqual:NLocalizedStr(@"Consult")]) {
        [self.navigationController pushViewController:[NYSCallCenterVC new] animated:YES];
        
    } else if ([model.title isEqual:NLocalizedStr(@"Recommend")]) {
        [self.navigationController pushViewController:[NYSRecommendVC new] animated:YES];
        
    } else if ([model.title isEqual:NLocalizedStr(@"Message")]) {
        [self.navigationController pushViewController:[NYSMessageCenterVC new] animated:YES];
        
    } else if ([model.title isEqual:NLocalizedStr(@"Interconnect")]) {
        NYSWebViewController *webVC = [NYSWebViewController new];
        webVC.autoTitle = YES;
        webVC.urlStr = ExternalUrl;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - Setter/Getter
- (NSMutableArray<NYSBannerModel *> *)bannerArray {
    if (!_bannerArray) {
        NYSBannerModel *banner1 = [NYSBannerModel modelWithJSON:@{@"image":@"/1656128373097OBS552bef2e2dc41c6af769c32707c1be.jpeg"}];
        NYSBannerModel *banner2 = [NYSBannerModel modelWithJSON:@{@"image":@"/1656128409034OBS694f38bb873ecd6910acbb2b494bb8.jpeg"}];
        _bannerArray = @[banner1, banner2].mutableCopy;
    }
    return _bannerArray;
}

- (NSMutableArray<NYSBusinessModel *> *)businessArray {
    if (!_businessArray) {
        NYSBusinessModel *business0 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"icon_item_00", @"title": NLocalizedStr(@"Consult")}];
        NYSBusinessModel *business1 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"icon_item_01", @"title": NLocalizedStr(@"Recommend")}];
        NYSBusinessModel *business2 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"icon_item_02", @"title": NLocalizedStr(@"Message")}];
        NYSBusinessModel *business3 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"icon_item_03", @"title": NLocalizedStr(@"Interconnect")}];
        _businessArray = @[business0, business1, business2, business3].mutableCopy;
    }
    return _businessArray;
}

- (NSMutableArray<NYSHomeCourseModel *> *)recommendedArray {
    if (!_recommendedArray) {
        _recommendedArray = @[].mutableCopy;
    }
    return _recommendedArray;
}

- (WMZBannerParam *)bannerParam {
    if (!_bannerParam) {
        _bannerParam = BannerParam()
            .wMyCellClassNameSet(@"NYSBannerCell")
            .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView, NSArray *dataArr) {
                NYSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSBannerCell class]) forIndexPath:indexPath];
                cell.bannerModel = model;
                return cell;
            })
            .wEventClickSet(^(id anyID, NSInteger index) {
                
            })
            .wFrameSet(CGRectMake(0, 0, NScreenWidth - 2 * NNormalSpace, HomeBannerHeight))
            .wItemSizeSet(CGSizeMake(NScreenWidth - 2 * NNormalSpace, HomeBannerHeight))
            .wScaleFactorSet(0.15f)
            .wScaleSet(NO)
            .wLineSpacingSet(NNormalSpace)
            .wRepeatSet(YES)
            .wAutoScrollSet(YES)
            .wAutoScrollSecondSet(5.0f)
            .wHideBannerControlSet(YES)
            .wDataSet(self.bannerArray);
    }
    return _bannerParam;
}

- (WMZBannerParam *)recommendedParam {
    if (!_recommendedParam) {
        _recommendedParam = BannerParam()
            .wMyCellClassNameSet(@"NYSRecommendedCell")
            .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView ,NSArray*dataArr) {
                NYSRecommendedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSRecommendedCell class]) forIndexPath:indexPath];
                cell.model = self.recommendedArray[indexPath.row];
                return cell;
            })
            .wEventClickSet(^(id anyID, NSInteger index) {
                NYSHomeCourseModel *model = self.recommendedArray[index];
                
                if ([model.is_activation isEqual:@"0"] || [model.is_course isEqual:@"0"]) {
                    NYSPurchasedCourseDetailVC *vc = NYSPurchasedCourseDetailVC.new;
                    vc.model = model;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    NYSCourseDetailVC *vc = NYSCourseDetailVC.new;
                    vc.model = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            })
            .wFrameSet(CGRectMake(0, 0, NScreenWidth, HomeRecommendedHeight))
            .wItemSizeSet(CGSizeMake(kScreenWidth * 0.85, HomeRecommendedHeight))
            .wSectionInsetSet(UIEdgeInsetsMake(0, NNormalSpace, 0, NNormalSpace))
            .wLineSpacingSet(20)
            .wHideBannerControlSet(YES)
            .wDataSet(self.recommendedArray);
    }
    return _recommendedParam;
}

@end
