//
//  NYSCourseListVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSCourseListVC.h"
#import "LayoutFittingView.h"
#import "NYSSearchCourseVC.h"

@interface NYSCourseListVC ()
<
SGPageTitleViewDelegate,
SGPageContentCollectionViewDelegate
>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation NYSCourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isShowLiftBack = NO;
    
    // 1.分页栏配置
    NSArray *titleArr = @[@"全部", @"老挝", @"中文", @"英文"];
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
    
    // 2.分页栏view
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, NScreenWidth*0.5, 44) delegate:self titleNames:titleArr configure:segmentConfigure];
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    self.pageTitleView
    .lee_theme.LeeAddCustomConfig(DAY, ^(SGPageTitleView *item) {
        [item resetTitleColor:[UIColor blackColor] titleSelectedColor:NAppThemeColor];
    }).LeeAddCustomConfig(NIGHT, ^(SGPageTitleView *item) {
        [item resetTitleColor:[UIColor lightGrayColor] titleSelectedColor:NAppThemeColor];
    });
    LayoutFittingView *LFView = [[LayoutFittingView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, 44)];
    [LFView addSubview:_pageTitleView];
    self.navigationItem.titleView = LFView;
    
    // 3.分页控制器
    NSMutableArray *childVCs = [NSMutableArray array];
    for (NSString *valueStr in valueArr) {
        NYSSearchCourseVC *hVC = [[NYSSearchCourseVC alloc] init];
        hVC.isShowBanner = YES;
        hVC.index = valueStr;
        [childVCs addObject:hVC];
    }
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) parentVC:self childVCs:childVCs];
    self.pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

#pragma mark - SGPagingViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

@end
