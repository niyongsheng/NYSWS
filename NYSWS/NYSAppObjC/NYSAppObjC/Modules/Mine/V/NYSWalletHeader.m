//
//  NYSWalletHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSWalletHeader.h"

@interface NYSWalletHeader ()
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation NYSWalletHeader

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ViewRadius(_withdrawBtn, 15);
    ViewRadius(_rechargeBtn, 15);
}

- (void)setMoneyStr:(NSString *)moneyStr {
    _moneyStr = moneyStr;
    
    _moneyL.text = moneyStr;
}

- (IBAction)withdrawBtnOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(@"2");
    }
}

- (IBAction)rechargeBtnOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(@"1");
    }
}

@end
