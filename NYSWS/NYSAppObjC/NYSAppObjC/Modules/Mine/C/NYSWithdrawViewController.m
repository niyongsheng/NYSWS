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
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
}

@end
