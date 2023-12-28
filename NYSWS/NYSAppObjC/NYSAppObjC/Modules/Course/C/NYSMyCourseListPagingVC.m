//
//  NYSMyCourseListPagingVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSMyCourseListPagingVC.h"
#import "LayoutFittingView.h"
#import "NYSMyCourseListVC.h"

@interface NYSMyCourseListPagingVC ()
<
SGPagingTitleViewDelegate,
SGPagingContentViewDelegate
>
@property (nonatomic, strong) SGPagingTitleView *pageTitleView;
@property (nonatomic, strong) SGPagingContentCollectionView *pageContentCollectionView;


@end

@implementation NYSMyCourseListPagingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.分页栏配置
//    NSArray *titleArr = @[@"已购", @"已学"];
    NSArray *titleArr = @[NLocalizedStr(@"Purchased"), NLocalizedStr(@"Learned")];
    NSArray *valueArr = @[@"1", @"0"];
    SGPagingTitleViewConfigure *segmentConfigure = [[SGPagingTitleViewConfigure alloc] init];
    segmentConfigure.indicatorType = IndicatorTypeCover;
    segmentConfigure.indicatorColor = NAppThemeColor;
    segmentConfigure.font = [UIFont boldSystemFontOfSize:15];
    segmentConfigure.color = NAppThemeColor;
    segmentConfigure.selectedColor = [UIColor whiteColor];
    segmentConfigure.indicatorHeight = 30;
    segmentConfigure.indicatorCornerRadius = 15;
    segmentConfigure.indicatorAdditionalWidth = 120;
    
    // 2.分页栏view
    self.pageTitleView = [[SGPagingTitleView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth*0.5, 30) titles:titleArr configure:segmentConfigure];
    _pageTitleView.delegate = self;
    _pageTitleView.layer.borderWidth = 1;
    _pageTitleView.layer.borderColor = [NAppThemeColor CGColor];
    _pageTitleView.layer.cornerRadius = 15;
    _pageTitleView.layer.masksToBounds = YES;
    self.pageTitleView.backgroundColor = [UIColor clearColor];

    self.navigationItem.titleView = _pageTitleView;
    
    // 3.分页控制器
    NSMutableArray *childVCs = [NSMutableArray array];
    for (NSString *valueStr in valueArr) {
        NYSMyCourseListVC *hVC = [[NYSMyCourseListVC alloc] init];
        hVC.index = valueStr;
        [childVCs addObject:hVC];
    }
    self.pageContentCollectionView = [[SGPagingContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) parentVC:self childVCs:childVCs];
    self.pageContentCollectionView.delegate = self;
    [self.view addSubview:_pageContentCollectionView];
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
