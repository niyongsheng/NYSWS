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
SGPageTitleViewDelegate,
SGPageContentCollectionViewDelegate
>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;


@end

@implementation NYSMyCourseListPagingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.分页栏配置
//    NSArray *titleArr = @[@"已购", @"已学"];
    NSArray *titleArr = @[NLocalizedStr(@"Purchased"), NLocalizedStr(@"Learned")];
    NSArray *valueArr = @[@"1", @"0"];
    SGPageTitleViewConfigure *segmentConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    segmentConfigure.indicatorStyle = SGIndicatorStyleCover;
    segmentConfigure.indicatorColor = NAppThemeColor;
    segmentConfigure.titleFont = [UIFont boldSystemFontOfSize:15];
    segmentConfigure.titleColor = NAppThemeColor;
    segmentConfigure.titleSelectedColor = [UIColor whiteColor];
    segmentConfigure.indicatorHeight = 30;
    segmentConfigure.indicatorCornerRadius = 15;
    segmentConfigure.indicatorAdditionalWidth = 120;
    
    // 2.分页栏view
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, NScreenWidth*0.5, 30) delegate:self titleNames:titleArr configure:segmentConfigure];
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
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) parentVC:self childVCs:childVCs];
    self.pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentCollectionViewDelegate
- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

@end
