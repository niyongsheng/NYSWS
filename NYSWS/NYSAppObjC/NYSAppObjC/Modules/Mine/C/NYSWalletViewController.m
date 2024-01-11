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

#define NAVBAR_COLORCHANGE_POINT 100

@interface NYSWalletViewController ()
{
    NSInteger _pageNo;
}
@property (strong, nonatomic) NYSRechargeAlertView *rechargeAlertView;
@end

@implementation NYSWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"MyWallet");
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NNotificationReloadWalletListData" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self->_pageNo = 0;
        [self footerRereshing];
    }];
    
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    [self setupUI];
    [self footerRereshing];
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
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight + NTopHeight));
    }];
    
    @weakify(self)
    NYSWalletHeader *headerView = [[NYSWalletHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
    headerView.moneyStr = NAppManager.userInfo.balance;
    headerView.block = ^(id obj) {
        if ([obj isEqual:@"1"]) {
            // 充值弹框
            self.rechargeAlertView.superVC = self;
            FFPopup *popup = [FFPopup popupWithContentView:self.rechargeAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
            FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
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
        @"page": @(_pageNo),
        @"limit": DefaultPageSize,
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/balance_record"
                                       parameters:argument
                                         remark:@"资金变动列表"
                                        success:^(id response) {
        @strongify(self)
        NSArray *array = [NSArray modelArrayWithClass:[NYSMovementModel class] json:response];
        if (array.count > 0) {
            if (self->_pageNo == 1) [self.dataSourceArr removeAllObjects];
            
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
    return 90;
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
    if ([model.order_id isNotBlank]) {
        NYSMovementDetailVC *vc = NYSMovementDetailVC.new;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NYSRechargeAlertView *)rechargeAlertView {
    if (!_rechargeAlertView) {
        CGFloat width = NScreenWidth;
        CGFloat height = 570 + NBottomHeight;
        _rechargeAlertView = [[NYSRechargeAlertView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _rechargeAlertView.isRecharge = YES;
    }
    return _rechargeAlertView;
}

#pragma mark - 导航栏透明化处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NTopHeight;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];

    } else {
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarTitleColor:[UIColor blackColor]];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

@end
