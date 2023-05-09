//
//  NYSPurchasedCourseDetailVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSPurchasedCourseDetailVC.h"
#import "NYSPurchasedDetailHeader.h"
#import "NYSLessonPlayCell.h"
#import "NYSCoursePurchaseVC.h"
#import "NYSCourseExchangeVC.h"

@interface NYSPurchasedCourseDetailVC ()
{
    NSInteger _pageNo;
}
@end

@implementation NYSPurchasedCourseDetailVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    
    [self wr_setNavBarBarTintColor:NAppThemeColor];
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    self.view.backgroundColor = NAppThemeColor;
    
    [self setupUI];
}

- (void)setupUI {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NYSTools addRoundedCorners:self.tableView corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:30];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    // 表头
    NYSPurchasedDetailHeader *headerView = [[NYSPurchasedDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {

    return NScreenHeight*0.2;
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"pageNo": @(_pageNo),
        @"pageSize": DefaultPageSize,
    };
    WS(weakSelf)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@""
                                       argument:argument
                                         remark:@"资金变动列表"
                                        success:^(id response) {
        NSArray *array = [NSArray modelArrayWithClass:[NYSMovementModel class] json:response[@"records"]];
        if (array.count > 0) {
            [weakSelf.dataSourceArr addObjectsFromArray:array];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"null"];
            }
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NetErr") reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _pageNo = 1;
    [self footerRereshing];
    
    return YES;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSLessonPlayCell";
    NYSLessonPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
//    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
