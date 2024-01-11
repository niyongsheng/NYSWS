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
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *customMoneyTF;

@end

@implementation NYSWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NLocalizedStr(@"Withdraw");

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    ViewRadius(_alipayAcccountTF, 2);
    
    self.moneyL.text = NAppManager.userInfo.balance;
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    if (![_alipayAcccountTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsAliPayAccount")];
        return;
    }
    
    if (![_nameTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsName")];
        return;
    }
    
    if (![_customMoneyTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsMoney")];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"money": _customMoneyTF.text,
        @"name": _nameTF.text,
        @"ali_account": _alipayAcccountTF.text
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                          url:@"/index/Member/withdrawal"
                                      parameters:params
                                             remark:@"提现"
                                            success:^(id response) {
        
        @strongify(self)
        [NYSTools showIconToast:NLocalizedStr(@"WithdrawalSubmitted") isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadWalletListData" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } failed:^(NSError * _Nullable error) {


    }];
}

@end
