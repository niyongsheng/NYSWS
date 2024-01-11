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
SGPagingTitleViewDelegate,
SGPagingContentViewDelegate
>
@property (nonatomic, strong) SGPagingTitleView *pageTitleView;
@property (nonatomic, strong) SGPagingContentCollectionView *pageContentCollectionView;

@end

@implementation NYSCourseListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NAppManager.isLogined ? [NAppManager loadUserInfoCompletion:nil] : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isShowLiftBack = NO;
    
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
        [NUserDefaults setValue:response forKey:@"Course_Class_List_C"];
        [NUserDefaults synchronize];
        for (NSDictionary *dict in response) {
            [valueArr addObject:dict[@"id"]];
            [titleArr addObject:dict[@"name"]];
        }
        [self layoutPagingView:titleArr valueArr:valueArr];

    } failed:^(NSError * _Nullable error) {
        @strongify(self)
        id response = [NUserDefaults valueForKey:@"Course_Class_List_C"];
        if (response) {
            for (NSDictionary *dict in response) {
                [valueArr addObject:dict[@"id"]];
                [titleArr addObject:dict[@"name"]];
            }
            [self layoutPagingView:titleArr valueArr:valueArr];
        }
    }];
}

- (void)layoutPagingView:(NSArray *)titleArr valueArr:(NSArray *)valueArr {
    // 1.分页栏配置
//        NSArray *titleArr = @[NSLocalizedStringFromTable(@"All", @"InfoPlist", nil),
//                              NSLocalizedStringFromTable(@"Laos", @"InfoPlist", nil),
//                              NSLocalizedStringFromTable(@"Chinese", @"InfoPlist", nil),
//                              NSLocalizedStringFromTable(@"English", @"InfoPlist", nil)];
//        NSArray *valueArr = @[@"0", @"1", @"2", @"3"];
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
    
    // 2.分页栏view
    self.pageTitleView = [[SGPagingTitleView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth * 0.75, 44) titles:titleArr configure:segmentConfigure];
    self.pageTitleView.delegate = self;
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    self.pageTitleView
    .lee_theme.LeeAddCustomConfig(DAY, ^(SGPagingTitleView *item) {
        [item resetTitleWithColor:[UIColor blackColor] selectedColor:NAppThemeColor];
    }).LeeAddCustomConfig(NIGHT, ^(SGPagingTitleView *item) {
        [item resetTitleWithColor:[UIColor lightGrayColor] selectedColor:NAppThemeColor];
    });
    LayoutFittingView *LFView = [[LayoutFittingView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, 44)];
    [LFView addSubview:self.pageTitleView];
    self.navigationItem.titleView = LFView;
    
    // 3.分页控制器
    NSMutableArray *childVCs = [NSMutableArray array];
    for (NSString *valueStr in valueArr) {
        NYSSearchCourseVC *hVC = [[NYSSearchCourseVC alloc] init];
        hVC.type = @"2";
        hVC.classId = valueStr;
        [childVCs addObject:hVC];
    }
    self.pageContentCollectionView = [[SGPagingContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) parentVC:self childVCs:childVCs];
        self.pageContentCollectionView.delegate = self;
    [self.view addSubview:self.pageContentCollectionView];
}

#pragma mark - SGPagingTitleViewDelegate
- (void)pagingTitleViewWithTitleView:(SGPagingTitleView *)titleView index:(NSInteger)index {
    [self.pageContentCollectionView setPagingContentViewWithIndex:index];
}

#pragma mark - SGPagingContentViewDelegate
- (void)pagingContentViewWithContentView:(SGPagingContentView *)contentView progress:(CGFloat)progress currentIndex:(NSInteger)currentIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPagingTitleViewWithProgress:progress currentIndex:currentIndex targetIndex:targetIndex];
}

@end
