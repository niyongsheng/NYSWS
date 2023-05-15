//
//  NYSRechargeViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSWithdrawViewController.h"

@interface NYSWithdrawViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UITextField *alipayAcccountTF;
@property (weak, nonatomic) IBOutlet UITextField *customMoneyTF;

@end

@implementation NYSWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    ViewRadius(_alipayAcccountTF, 2);
    
    self.moneyL.text = NAppManager.userInfo.balance;
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    if (![_alipayAcccountTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入支付宝账户"];
        return;
    }
    
    if (![_customMoneyTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入提现金额"];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"name": NAppManager.userInfo.nickname,
        @"money": _customMoneyTF.text,
        @"ali_account": _alipayAcccountTF.text
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Member/withdrawal"
                                      argument:params
                                             remark:@"提现"
                                            success:^(id response) {
        
        @strongify(self)
        [NYSTools showIconToast:@"已提交提现申请" isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } failed:^(NSError * _Nullable error) {


    }];
}

@end
