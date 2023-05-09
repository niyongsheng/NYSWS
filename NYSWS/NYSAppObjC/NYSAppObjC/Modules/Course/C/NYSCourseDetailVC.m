//
//  NYSCourseDetailVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCourseDetailVC.h"
#import "NYSCourseDetailHeader.h"
#import "NYSLessonPlayCell.h"
#import "NYSCoursePurchaseVC.h"
#import "NYSCourseExchangeVC.h"

#define BottomBtnHeight 50

@interface NYSCourseDetailVC ()
{
    NSInteger _pageNo;
}
@end

@implementation NYSCourseDetailVC

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
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight - BottomBtnHeight));
    }];
    
    // 表头
    NYSCourseDetailHeader *headerView = [[NYSCourseDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 350)];
    self.tableView.tableHeaderView = headerView;
    
    // 购买兑换
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - BottomBtnHeight, kScreenWidth/2, BottomBtnHeight)];
    leftBtn.tag = 11;
    [leftBtn addTarget:self action:@selector(bottomBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"兑换激活" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFB433"]];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight - BottomBtnHeight, kScreenWidth/2, BottomBtnHeight)];
    rightBtn.tag = 22;
    [rightBtn addTarget:self action:@selector(bottomBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor colorWithHexString:@"#FE6A48"]];
    [self.view addSubview:rightBtn];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)bottomBtnOnclicked:(UIButton *)sender {
    if (sender.tag == 11) {
        [self.navigationController pushViewController:NYSCourseExchangeVC.new animated:YES];
    } else {
        
        [self.navigationController pushViewController:NYSCoursePurchaseVC.new animated:YES];
    }
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
