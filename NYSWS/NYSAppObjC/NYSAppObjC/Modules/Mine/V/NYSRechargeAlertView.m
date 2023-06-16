//
//  NYSWalletHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSRechargeAlertView.h"
#import "NYSMoneyItemView.h"

@interface NYSRechargeAlertView ()
<
UITextFieldDelegate,
NYSMoneyItemViewDelegate
>
@property (weak, nonatomic) IBOutlet UIView *moneyView;

/// 自定义金额View
@property (weak, nonatomic) IBOutlet UIView *customV;
@property (weak, nonatomic) IBOutlet UITextField *customTF;
@property (weak, nonatomic) IBOutlet UILabel *customCoinL;

/// 支付方式
@property (weak, nonatomic) IBOutlet UIButton *payWayBtn0;
@property (weak, nonatomic) IBOutlet UIView *payWayV0;
@property (weak, nonatomic) IBOutlet UIView *payWayV1;
@property (weak, nonatomic) IBOutlet UIView *payWayV2;
@property (weak, nonatomic) IBOutlet UIView *payWayV3;
@property (weak, nonatomic) IBOutlet UIView *payWayV4;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) NSMutableArray *moneyViewArr;
@property (nonatomic, strong) NSArray *paywayViewArr;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSArray *priceArr;
@end

@implementation NYSRechargeAlertView

- (void)setupView {
    self.customTF.delegate = self;
    self.customTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    ViewBorderRadius(_customV, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    
    ViewBorderRadius(_payWayV0, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV1, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV2, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV3, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    ViewBorderRadius(_payWayV4, 22.5, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    
    ViewRadius(_commitBtn, 22.5);
    
    [NYSTools addRoundedCorners:self corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
    
    // 默认第一种支付方式
    [self payWayBtnOnclicked:self.payWayBtn0];
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/get_money"
                                       argument:nil
                                         remark:@"获取充值固定金额"
                                        success:^(id response) {
        NSArray *dataArray = [NSArray modelArrayWithClass:[NYSMoneyItemModel class] json:response];
        
        @strongify(self)
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.moneyView.width, self.moneyView.height)];
        scrollView.showsVerticalScrollIndicator = YES;
        [self.moneyView addSubview:scrollView];
        CGFloat marginX = 10; // 按钮左右边缘距离
        CGFloat marginY = 0; // 距离上下边缘距离
        CGFloat toTop = 0; // 按钮距离顶部的距离
        CGFloat gapX = 10; // 左右按钮之间的距离
        CGFloat gapY = 10; // 上下按钮之间的距离
        NSInteger count = [dataArray count]; // 这里先设置布局任意个按钮
        NSInteger col = 3; // 列
        NSInteger row = count/col; // 行
        if (count % col > 0) {
            row += 1;
        }
        CGFloat viewWidth = self.moneyView.bounds.size.width; // 视图的宽度
        CGFloat viewHeight = self.moneyView.bounds.size.height; // 视图的高度
        // 根据列数 和 按钮之间的间距 这些参数基本可以确定要平铺的按钮的宽度
        CGFloat itemWidth = (viewWidth - marginX *2- (col -1)*gapX)/col*1.0f;
        CGFloat itemHeight = itemWidth;
        NYSMoneyItemView *last = nil; // 上一个按钮
        // 开始布局
        for (int i =0; i < count; i++) {
            NYSMoneyItemView *item = [NYSMoneyItemView new];
            item.delegate = self;
            ViewBorderRadius(item, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
            NYSMoneyItemModel *model = dataArray[i];
            item.model = model;
            item.index = i;
            [scrollView addSubview:item];
            [self.moneyViewArr addObject:item];

            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemWidth);
                make.height.mas_equalTo(itemHeight);
                // topTop距离顶部的距离，多行，需要计算距离顶部的距离
                // 计算距离顶部的距离 --- 根据换行
                CGFloat top = toTop + marginY + (i/col)*(itemHeight+gapY);
                make.top.mas_offset(top);
                if (!last || (i%col) == 0) { // last为nil  或者(i%col) == 0 说明换行了 每行的第一个确定它距离左边边缘的距离
                    make.left.mas_offset(marginX);
                } else {
                    // 第二个或者后面的按钮 距离前一个按钮右边的距离都是gap个单位
                    make.left.mas_equalTo(last.mas_right).mas_offset(gapX);
                }
            }];
            last = item;
        }
        
        CGFloat contentH = itemHeight * row + (row - 1) * gapY;
        scrollView.contentSize = CGSizeMake(0, contentH);

    } failed:^(NSError * _Nullable error) {

    }];
    
    
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/get_pay"
                                       argument:nil
                                         remark:@"获取支付方式"
                                        success:^(id response) {
        @strongify(self)
        NSArray *dataArray = [NSArray modelArrayWithClass:[NYSPayWayModel class] json:response];
        for (NYSPayWayModel *model in dataArray) {
            if ([model.config isEqualToString:@"wechat_pay"]) {
                self.payWayV0.hidden = NO;
            } else if ([model.config isEqualToString:@"alipay"]) {
                self.payWayV1.hidden = NO;
            } else if ([model.config isEqualToString:@"foreign_pay"]) {
                self.payWayV2.hidden = NO;
            } else if ([model.config isEqualToString:@"bank_pay"]) {
                self.payWayV3.hidden = NO;
            } else if ([model.config isEqualToString:@"apple_pay"]) {
                self.payWayV4.hidden = NO;
            }
        }

    } failed:^(NSError * _Nullable error) {

    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    for (NYSMoneyItemView *view in self.moneyViewArr) {
        ViewBorderRadius(view, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    }
    
    self.customCoinL.text = textField.text;
    self.price = textField.text;
}

- (NSArray *)priceArr {
    if (!_priceArr) {
        _priceArr = @[@"20", @"60", @"980", @"20", @"30", @"10"];
    }
    return _priceArr;
}

- (NSMutableArray *)moneyViewArr {
    if (!_moneyViewArr) {
        _moneyViewArr = [NSMutableArray array];
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

#pragma mark - NYSMoneyItemViewDelegate
- (void)moneyItemViewOnclicked:(NSInteger)index {
    for (NYSMoneyItemView *view in self.moneyViewArr) {
        ViewBorderRadius(view, 10, 1, [UIColor colorWithHexString:@"#E6E6E6"]);
    }
    
    NYSMoneyItemView *selectedView = self.moneyViewArr[index];
    ViewBorderRadius(selectedView, 10, 1.2, NAppThemeColor);
    
    self.price = selectedView.model.money;
    
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
        
        [self commitPay];
        
    } else {
        [FFPopup dismissAllPopups];
    }
}

#pragma mark - 充值
- (void)commitPay {
    
    if (![self.price isNotBlank]) {
        [NYSTools showToast:@"请选择金额"];
        return;
    }
    
    NSMutableDictionary *argument = @{@"price" : self.price}.mutableCopy;
    switch (self.payType) {
        case 0: {
            [NYSTools showToast:@"wechatPay"];
            [argument setValue:@0 forKey:@"pay_type"];
        }
            break;
            
        case 1: {
            [NYSTools showToast:@"aliPay"];
            [argument setValue:@1 forKey:@"pay_type"];
        }
            break;
            
        case 2: {
            [NYSTools showToast:@"payPay"];
            [argument setValue:@4 forKey:@"pay_type"];
        }
            break;
            
        case 3: {
            [NYSTools showToast:@"bankPay"];
            [argument setValue:@3 forKey:@"pay_type"];
        }
            break;
            
        case 4: {
            [NYSTools showToast:@"applePay"];
            [argument setValue:@2 forKey:@"pay_type"];
        }
            break;
            
        default:
            break;
    }
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Order/create"
                                       argument:argument
                                             remark:@"下单调起支付"
                                            success:^(id response) {
        @strongify(self)
        if (self.payType == 0) {
            NSString *url = [NSString stringWithFormat:@"weixin://%@", response];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
            if (canOpen) {
//                PayReq *request = [[PayReq alloc] init];
//                request.partnerId = response[@"partnerId"];
//                request.prepayId = response[@"prepayId"];
//                request.package = @"Sign=WXPay";
//                request.nonceStr = response[@"nonceStr"];
//                request.timeStamp = [NYSTools getNowTimeTimestamp].unsignedIntValue;
//                request.sign = response[@"sign"];
//                [WXApi sendReq:request];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NLocalizedStr(@"Tips") message:NLocalizedStr(@"UninstallWechat") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NLocalizedStr(@"OK") style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self.superVC presentViewController:alert animated:YES completion:nil];
            }
            
        } else if (self.payType == 1) {
            NSString *url = [NSString stringWithFormat:@"alipay://%@", response];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
            if (canOpen) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NLocalizedStr(@"Tips") message:NLocalizedStr(@"UninstallAlipay") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NLocalizedStr(@"OK") style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self.superVC presentViewController:alert animated:YES completion:nil];
            }
        } else if (self.payType == 2) {
            SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:response[@"url"]]];
            [self.superVC presentViewController:sfVC animated:YES completion:nil];
            
        }  else if (self.payType == 3) {
            
        } else if (self.payType == 4) {
            
        }
        
        [FFPopup dismissAllPopups];

    } failed:^(NSError * _Nullable error) {
        
    }];
}

@end
