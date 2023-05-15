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
            FFPopup *popup = [FFPopup popupWithContentView:self.rechargeAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
            FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
            self.rechargeAlertView.block = ^(id obj) {
                [popup dismissAnimated:YES];
                
                @strongify(self)
                if ([obj isKindOfClass:NSDictionary.class]) {
                    [self commitPay:obj];
                }
            };
            [popup showWithLayout:layout];
        } else {
            [self.navigationController pushViewController:NYSWithdrawViewController.new animated:YES];
        }
    };
    self.tableView.tableHeaderView = headerView;
}

- (void)commitPay:(NSDictionary *)obj {
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Order/create"
                                      argument:obj
                                             remark:@"下单调起支付"
                                            success:^(id response) {
        @strongify(self)
        if ([obj[@"pay_type"] intValue] == 0) {
            NSString *url = [NSString stringWithFormat:@"weixin://%@", response];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
            if (canOpen) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你尚未安装微信APP" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } else if ([obj[@"pay_type"] intValue] == 1) {
            NSString *url = [NSString stringWithFormat:@"alipay://%@", response];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
            if (canOpen) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你尚未安装支付宝APP" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        

    } failed:^(NSError * _Nullable error) {
        
    }];
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
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/balance_record"
                                       argument:argument
                                         remark:@"资金变动列表"
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
        }
        
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NetErr") reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
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
    }
    return _rechargeAlertView;
}

@end
