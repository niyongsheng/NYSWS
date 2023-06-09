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
#import "NYSHomeCourseVC.h"

#import "NYSCallCenterVC.h"
#import "NYSRecommendVC.h"
#import "NYSMessageCenterVC.h"

#import "NYSCourseDetailVC.h"
#import "NYSPurchasedCourseDetailVC.h"
#import "NYSCatalogViewController.h"

#import "ThirdViewController.h"

#define HomeBannerHeight        RealValue(180)
#define HomeRecommendedHeight   RealValue(150)

@interface NYSHomeViewController ()
<
PopTableCellDelegate,
UIScrollViewDelegate,
SGPageTitleViewDelegate,
SGPageContentCollectionViewDelegate,
NYSBusinessViewDelegate
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
@property (nonatomic, strong) NSMutableArray<NYSRecommendedModel *> *recommendedArray;

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@property (nonatomic, strong) PopView *popView;
@property (nonatomic, strong) PopTableListView *popListView;
@end

@implementation NYSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"CFBundleDisplayName");
    
    [self setupNav];
    [self setupUI];
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
        }];
    } else {
        [self showHUDCompletion:^{
            [NYSUIKitUtilities setUserLanguage:@"lo"];
        }];
    }

    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0.5;
    } completion:^(BOOL finished) {
        exit(0);
    }];

}

- (void)showHUDCompletion:(void (^ __nullable)(void))completion {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    [self presentViewController:vc animated:NO completion:completion];
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

- (void)setupUI {
    CGFloat h = 0;
    
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
//    [searchBtn setBackgroundColor:UIColor.redColor];
    [searchBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NYSSearchCourseVC *searchVC = [NYSSearchCourseVC new];
        [self.navigationController pushViewController:searchVC animated:YES];
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
    NSArray *titleArr = @[NSLocalizedStringFromTable(@"All", @"InfoPlist", nil),
                          NSLocalizedStringFromTable(@"Laos", @"InfoPlist", nil),
                          NSLocalizedStringFromTable(@"Chinese", @"InfoPlist", nil),
                          NSLocalizedStringFromTable(@"English", @"InfoPlist", nil)];
    NSArray *valueArr = @[@"0", @"1", @"2", @"3"];
    SGPageTitleViewConfigure *segmentConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    segmentConfigure.indicatorStyle = SGIndicatorStyleDefault;
    segmentConfigure.indicatorColor = NAppThemeColor;
    segmentConfigure.showBottomSeparator = NO;
    segmentConfigure.indicatorHeight = 4;
    segmentConfigure.indicatorCornerRadius = 2;
    segmentConfigure.indicatorToBottomDistance = 10;
    segmentConfigure.indicatorScrollStyle = SGIndicatorScrollStyleDefault;
    segmentConfigure.titleFont = [UIFont boldSystemFontOfSize:15.0];
    segmentConfigure.titleTextZoom = YES;
    segmentConfigure.titleTextZoomRatio = .6f;

    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, h, kScreenWidth * 0.75, 44) delegate:self titleNames:titleArr configure:segmentConfigure];
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    self.pageTitleView
    .lee_theme.LeeAddCustomConfig(DAY, ^(SGPageTitleView *item) {
        [item resetTitleColor:[UIColor blackColor] titleSelectedColor:NAppThemeColor];
    }).LeeAddCustomConfig(NIGHT, ^(SGPageTitleView *item) {
        [item resetTitleColor:[UIColor lightGrayColor] titleSelectedColor:NAppThemeColor];
    });
    [self.containerScrollView addSubview:_pageTitleView];
    
    NSMutableArray *childVCs = [NSMutableArray array];
    for (NSString *valueStr in valueArr) {
        NYSHomeCourseVC *hVC = [[NYSHomeCourseVC alloc] init];
        hVC.index = valueStr;
        [childVCs addObject:hVC];
    }
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, h+44, kScreenWidth, kScreenHeight) parentVC:self childVCs:childVCs];
    self.pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.containerScrollView addSubview:_pageContentCollectionView];
    
    // 可滚动范围
    self.containerScrollView.contentSize = CGSizeMake(0, self.pageContentCollectionView.bottom + NNormalSpace);
}

#pragma mark - SGPagingViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
        [self.navigationController pushViewController:[NYSMessageCenterVC new] animated:YES];
    }
}

#pragma mark - Setter/Getter
- (NSMutableArray<NYSBannerModel *> *)bannerArray {
    if (!_bannerArray) {
        NYSBannerModel *banner1 = [NYSBannerModel modelWithJSON:@{@"bannerUrl":@"/1656128373097OBS552bef2e2dc41c6af769c32707c1be.jpeg"}];
        NYSBannerModel *banner2 = [NYSBannerModel modelWithJSON:@{@"bannerUrl":@"/1656128409034OBS694f38bb873ecd6910acbb2b494bb8.jpeg"}];
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

- (NSMutableArray<NYSRecommendedModel *> *)recommendedArray {
    if (!_recommendedArray) {
        NYSRecommendedModel *billboard = [NYSRecommendedModel new];
        _recommendedArray = @[billboard, billboard, billboard].mutableCopy;
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
            if (index == 0) {
                NYSCourseDetailVC *vc = NYSCourseDetailVC.new;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if (index == 1) {
                
                NYSPurchasedCourseDetailVC *vc = NYSPurchasedCourseDetailVC.new;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                
                NYSCatalogViewController *vc = NYSCatalogViewController.new;
                [self.navigationController pushViewController:vc animated:YES];
            }
        })
        .wFrameSet(CGRectMake(0, 0, NScreenWidth, HomeRecommendedHeight))
        .wItemSizeSet(CGSizeMake(kScreenWidth * 0.85, HomeRecommendedHeight))
        .wSectionInsetSet(UIEdgeInsetsMake(0, NNormalSpace, 0, 0))
        .wLineSpacingSet(20)
        .wHideBannerControlSet(YES)
        .wDataSet(self.recommendedArray);
    }
    return _recommendedParam;
}

@end
