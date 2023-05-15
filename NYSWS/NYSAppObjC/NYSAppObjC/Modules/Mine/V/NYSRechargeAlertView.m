//
//  NYSWalletHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSRechargeAlertView.h"

@interface NYSRechargeAlertView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *moneyV0;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn0;
@property (weak, nonatomic) IBOutlet UIView *lineV0;
@property (weak, nonatomic) IBOutlet UILabel *moneyL0;
@property (weak, nonatomic) IBOutlet UILabel *coinL0;

@property (weak, nonatomic) IBOutlet UIView *moneyV1;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn1;
@property (weak, nonatomic) IBOutlet UIView *lineV1;
@property (weak, nonatomic) IBOutlet UILabel *moneyL1;
@property (weak, nonatomic) IBOutlet UILabel *coinL1;

@property (weak, nonatomic) IBOutlet UIView *moneyV2;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn2;
@property (weak, nonatomic) IBOutlet UIView *lineV2;
@property (weak, nonatomic) IBOutlet UILabel *moneyL2;
@property (weak, nonatomic) IBOutlet UILabel *coinL2;

@property (weak, nonatomic) IBOutlet UIView *moneyV3;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn3;
@property (weak, nonatomic) IBOutlet UIView *lineV3;
@property (weak, nonatomic) IBOutlet UILabel *moneyL3;
@property (weak, nonatomic) IBOutlet UILabel *coinL3;

@property (weak, nonatomic) IBOutlet UIView *moneyV4;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn4;
@property (weak, nonatomic) IBOutlet UIView *lineV4;
@property (weak, nonatomic) IBOutlet UILabel *moneyL4;
@property (weak, nonatomic) IBOutlet UILabel *coinL4;

@property (weak, nonatomic) IBOutlet UIView *moneyV5;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn5;
@property (weak, nonatomic) IBOutlet UIView *lineV5;
@property (weak, nonatomic) IBOutlet UILabel *moneyL5;
@property (weak, nonatomic) IBOutlet UILabel *coinL5;

@property (weak, nonatomic) IBOutlet UIView *customV;
@property (weak, nonatomic) IBOutlet UITextField *customTF;
@property (weak, nonatomic) IBOutlet UILabel *customCoinL;

@property (weak, nonatomic) IBOutlet UIButton *payWayBtn0;

@property (weak, nonatomic) IBOutlet UIView *payWayV0;
@property (weak, nonatomic) IBOutlet UIView *payWayV1;
@property (weak, nonatomic) IBOutlet UIView *payWayV2;
@property (weak, nonatomic) IBOutlet UIView *payWayV3;
@property (weak, nonatomic) IBOutlet UIView *payWayV4;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) NSArray *moneyViewArr;
@property (nonatomic, strong) NSArray *paywayViewArr;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSArray *priceArr;
@end

@implementation NYSRechargeAlertView

- (void)setupView {
    self.customTF.delegate = self;
    self.customTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    ViewBorderRadius(_moneyV0, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_moneyV1, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_moneyV2, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_moneyV3, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_moneyV4, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_moneyV5, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    
    ViewBorderRadius(_customV, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    
    ViewBorderRadius(_payWayV0, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV1, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV2, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV3, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV4, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    
    ViewRadius(_commitBtn, 22.5);
    
    [NYSTools addRoundedCorners:self corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
    
    [self payMoneyBtnOnclicked:self.moneyBtn0];
    [self payWayBtnOnclicked:self.payWayBtn0];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    self.customCoinL.text = textField.text;
    self.price = textField.text;
}

- (NSArray *)priceArr {
    if (!_priceArr) {
        _priceArr = @[@"20", @"60", @"980", @"20", @"30", @"10"];
    }
    return _priceArr;
}

- (NSArray *)moneyViewArr {
    if (!_moneyViewArr) {
        _moneyViewArr = @[
            self.moneyV0,
            self.moneyV1,
            self.moneyV2,
            self.moneyV3,
            self.moneyV4,
            self.moneyV5,
        ];
    }
    return _moneyViewArr;
}

- (NSArray *)paywayViewArr {
    if (!_paywayViewArr) {
        _paywayViewArr = @[
            self.payWayV0,
            self.payWayV1,
            self.payWayV2,
            self.payWayV3,
            self.payWayV4,
        ];
    }
    return _paywayViewArr;
}

- (IBAction)payMoneyBtnOnclicked:(UIButton *)sender {
    for (UIView *view in self.moneyViewArr) {
        ViewBorderRadius(view, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    }
    
    UIView *view = self.moneyViewArr[sender.tag];
    ViewBorderRadius(view, 10, 1.2, NAppThemeColor);
    
    self.price = self.priceArr[sender.tag];
}

- (IBAction)payWayBtnOnclicked:(UIButton *)sender {
    for (UIView *view in self.paywayViewArr) {
        ViewBorderRadius(view, 22.5, 1.2, [UIColor colorWithHexString:@"#E6E6E6"]);
    }
    
    UIView *view = self.paywayViewArr[sender.tag];
    ViewBorderRadius(view, 22.5, 1, NAppThemeColor);
    
    self.payType = sender.tag;
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    if ([sender isEqual:self.commitBtn]) {
        [NYSTools zoomToShow:sender.layer];
        
        if (_block) {
            self.block(@{
                @"price" : _price,
                @"pay_type" : @(_payType)
            });
        }
        
    } else {
        if (_block) {
            self.block(@"0");
        }
    }
}

@end
