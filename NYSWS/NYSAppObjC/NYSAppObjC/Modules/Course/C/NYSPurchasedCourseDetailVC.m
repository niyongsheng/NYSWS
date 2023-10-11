//
//  NYSPurchasedCourseDetailVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSPurchasedCourseDetailVC.h"
#import "NYSPurchasedDetailHeader.h"
#import "NYSCourseDetailHeader.h"
#import "NYSLessonPlayCell.h"
#import "NYSCoursePurchaseVC.h"
#import "NYSCourseExchangeVC.h"
#import "NYSCatalogViewController.h"
#import "NYSCacheViewController.h"

@interface NYSPurchasedCourseDetailVC ()
{
    NSInteger _pageNo;
}
@property (strong, nonatomic) NYSPurchasedDetailHeader *headerView;
@property (strong, nonatomic) NYSCourseDetailHeader *headerViewNew;
@end

@implementation NYSPurchasedCourseDetailVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"Detail");
    
    [self wr_setNavBarBarTintColor:NAppThemeColor];
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    [self setupUI];
    
    if (self.isOffLine) {
        self.headerViewNew.model = self.detailModel;
        
        NSMutableAttributedString *aStr = [NYSCustomLabel getAttributedString:self.detailModel.details];
        CGRect frame = [NYSCustomLabel getAttributedStringFrame:aStr width:kScreenWidth - 30];
        self.tableView.tableHeaderView.height = 300 + frame.size.height;
        
        self.dataSourceArr = self.detailModel.chapter.mutableCopy;
        [self.tableView reloadData];
        
    } else {
        [self getDetailData];
    }
}

- (void)setupUI {
    
    _tableviewStyle = UITableViewStylePlain;
    self.tableView.refreshControl = nil;
    self.tableView.mj_footer = nil;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.tableView];
    
    // 表头
    self.headerView = [[NYSPurchasedDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.headerViewNew = [[NYSCourseDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    self.headerViewNew.isHiddenPrice = YES;
    self.tableView.tableHeaderView = self.headerViewNew;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return NScreenHeight*0.3;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

#pragma mark - 加载详情数据
- (void)getDetailData {
    NSMutableDictionary *params = @{
        @"course_id": @(self.model.ID),
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Course/info"
                                      argument:params
                                             remark:@"课程详情"
                                            success:^(id response) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailModel = [NYSHomeCourseModel modelWithDictionary:response];
            self.headerViewNew.model = self.detailModel;
            
            NSMutableAttributedString *aStr = [NYSCustomLabel getAttributedString:self.detailModel.details];
            CGRect frame = [NYSCustomLabel getAttributedStringFrame:aStr width:kScreenWidth - 30];
            self.tableView.tableHeaderView.height = 300 + frame.size.height;
            
            self.dataSourceArr = self.detailModel.chapter.mutableCopy;
            [self.tableView reloadData];
            
        });
    } failed:^(NSError * _Nullable error) {


    }];
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"page": @(_pageNo),
        @"limit": DefaultPageSize,
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@""
                                       argument:argument
                                         remark:@"课程章节列表"
                                        success:^(id response) {
        @strongify(self)
        NSArray *array = [NSArray modelArrayWithClass:[NYSMovementModel class] json:response];
        if (array.count > 0) {
            [self.dataSourceArr addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:self.dataSourceArr.count == 0];
        }
        
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSString *description = error.localizedDescription;
        if (![description isNotBlank]) {
            description = NLocalizedStr(@"NetErr");
        }
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:description reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSChapter *model = self.dataSourceArr[indexPath.row];
    CGFloat h = [model.subtitle heightForFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 170];
    return 50 + h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSLessonPlayCell";
    NYSLessonPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.isActived = YES;
    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isOffLine) {
        NYSCacheViewController *vc = NYSCacheViewController.new;
        vc.courseId = self.model.ID;
        vc.index = indexPath.row;
        vc.chapterArray = self.dataSourceArr;
        vc.courseModel = self.model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        NYSCatalogViewController *vc = NYSCatalogViewController.new;
        vc.courseId = self.model.ID;
        vc.index = indexPath.row;
        vc.chapterArray = self.dataSourceArr;
        vc.courseModel = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
