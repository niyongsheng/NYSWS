//
//  NYSWalletViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSWalletViewController.h"
#import "NYSWalletHeader.h"
#import "NYSWalletMovemenCell.h"
#import "NYSMovementDetailVC.h"
#import "NYSWithdrawViewController.h"
#import "NYSRechargeAlertView.h"

@interface NYSWalletViewController ()
{
    NSInteger _pageNo;
}
@property (strong, nonatomic) NYSRechargeAlertView *rechargeAlertView;
@end

@implementation NYSWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
    
    [self wr_setNavBarBackgroundAlpha:0];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    [self setupUI];
}

- (void)setupUI {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(-NTopHeight);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    
    NYSWalletHeader *headerView = [[NYSWalletHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
    headerView.block = ^(id obj) {
        if ([obj isEqual:@"1"]) {
            // 充值弹框
            FFPopup *popup = [FFPopup popupWithContentView:self.rechargeAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
            FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
            self.rechargeAlertView.block = ^(id obj) {
                [popup dismissAnimated:YES];
                
                
                
            };
            [popup showWithLayout:layout];
        } else {
            [self.navigationController pushViewController:NYSWithdrawViewController.new animated:YES];
        }
    };
    self.tableView.tableHeaderView = headerView;
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
    static NSString *ID = @"NYSWalletMovemenCell";
    NYSWalletMovemenCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NYSMovementModel *model = self.dataSourceArr[indexPath.row];
    NYSMovementDetailVC *vc = NYSMovementDetailVC.new;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NYSRechargeAlertView *)rechargeAlertView {
    if (!_rechargeAlertView) {
        CGFloat width = NScreenWidth;
        CGFloat height = 570 + NBottomHeight;
        _rechargeAlertView = [[NYSRechargeAlertView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    return _rechargeAlertView;
}

@end
