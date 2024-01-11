//
//  NYSWalletHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSRechargeAlertView.h"
#import "NYSMoneyItemView.h"
#import "NYSPayAlertView.h"
#import "EMAppStorePay.h"

@interface NYSRechargeAlertView ()
<
UITextFieldDelegate,
NYSMoneyItemViewDelegate,
EMAppStorePayDelegate
>
@property (strong, nonatomic) EMAppStorePay *appStorePay;
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

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *applePayId;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSArray *priceArr;

@property (nonatomic, strong) NYSPayAlertView *payAlertView;
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
    //    [self payWayBtnOnclicked:self.payWayBtn0];
    
    [self getMoneyData];
}

/// 加载充值金额数据
- (void)getMoneyData {
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/get_money"
                                       parameters:nil
                                         remark:@"获取充值固定金额"
                                        success:^(id response) {
        NSArray *dataArray = [NSArray modelArrayWithClass:[NYSMoneyItemModel class] json:response];
        
        @strongify(self)
        [self.moneyView removeAllSubviews];
        [self.moneyViewArr removeAllObjects];
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
}

/// 加载苹果内购充值金额数据
- (void)getApplePayMoneyData {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NYSMoneyItemModel *mimodel = [NYSMoneyItemModel new];
    mimodel.money = @"1";
    mimodel.applePayId = @"com.innerpay.xueyidian1";
    [dataArray addObject:mimodel];
    
    NYSMoneyItemModel *mimodel12 = [NYSMoneyItemModel new];
    mimodel12.money = @"12";
    mimodel12.applePayId = @"com.innerpay.xueyidian12";
    [dataArray addObject:mimodel12];
    
    NYSMoneyItemModel *mimodel58 = [NYSMoneyItemModel new];
    mimodel58.money = @"58";
    mimodel58.applePayId = @"com.innerpay.xueyidian58";
    [dataArray addObject:mimodel58];
    
    NYSMoneyItemModel *mimodel128 = [NYSMoneyItemModel new];
    mimodel128.money = @"128";
    mimodel128.applePayId = @"com.innerpay.xueyidian128";
    [dataArray addObject:mimodel128];
    
    NYSMoneyItemModel *mimodel298 = [NYSMoneyItemModel new];
    mimodel298.money = @"298";
    mimodel298.applePayId = @"com.innerpay.xueyidian298";
    [dataArray addObject:mimodel298];
    
    NYSMoneyItemModel *mimodel598 = [NYSMoneyItemModel new];
    mimodel598.money = @"598";
    mimodel598.applePayId = @"com.innerpay.xueyidian598";
    [dataArray addObject:mimodel598];
    
    [self.moneyView removeAllSubviews];
    [self.moneyViewArr removeAllObjects];
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
}

- (void)layoutSubviews {
    @weakify(self)
    
    self.payWayV0.hidden = YES;
    self.payWayV1.hidden = YES;
    self.payWayV2.hidden = YES;
    self.payWayV3.hidden = YES;
    self.payWayV4.hidden = YES;
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/get_pay"
                                       parameters:nil
                                         remark:@"获取支付方式"
                                        success:^(id response) {
        @strongify(self)
        NSArray *dataArray = [NSArray modelArrayWithClass:[NYSPayWayModel class] json:response];
        BOOL payWayV0Hidden = YES;
        BOOL payWayV1Hidden = YES;
        BOOL payWayV2Hidden = YES;
        BOOL payWayV3Hidden = YES;
        for (NYSPayWayModel *model in dataArray) {
            if ([model.config isEqualToString:@"wechat_pay"]) {
                if ([model.value isEqual:@"0"]) {
                    payWayV0Hidden = NO;
                    self.payWayV0.hidden = NO;
                }
            } else if ([model.config isEqualToString:@"alipay"]) {
                if ([model.value isEqual:@"0"]) {
                    payWayV1Hidden = NO;
                    self.payWayV1.hidden = NO;
                }
            } else if ([model.config isEqualToString:@"foreign_pay"]) {
                if ([model.value isEqual:@"0"]) {
                    payWayV2Hidden = NO;
                    self.payWayV2.hidden = NO;
                }
            } else if ([model.config isEqualToString:@"bank_pay"]) {
                if ([model.value isEqual:@"0"])
                    payWayV3Hidden = NO;
                    self.payWayV3.hidden = NO;
            } else if ([model.config isEqualToString:@"apple_pay"]) {
                if ([model.value isEqual:@"0"])
                    self.payWayV4.hidden = NO;
            }
        }
        
        if (payWayV0Hidden) {
            self.payWayV1.left = 0;
            self.payWayV2.left = self.payWayV1.right + 10;
        }
        if (payWayV0Hidden && payWayV1Hidden) {
            self.payWayV2.left = 0;
        } else if (payWayV0Hidden && !payWayV1Hidden) {
            self.payWayV2.left = self.payWayV1.right + 10;
        } else if (!payWayV0Hidden && payWayV1Hidden) {
            self.payWayV2.left = self.payWayV0.right + 10;
        }
        
        if (payWayV3Hidden) {
            self.payWayV4.left = 0;
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
    self.applePayId = selectedView.model.applePayId;
}

- (IBAction)payWayBtnOnclicked:(UIButton *)sender {
    for (UIView *view in self.paywayViewArr) {
        ViewBorderRadius(view, 22.5, 1.2, [UIColor colorWithHexString:@"#E6E6E6"]);
    }
    
    UIView *view = self.paywayViewArr[sender.tag];
    ViewBorderRadius(view, 22.5, 1, NAppThemeColor);
    
    self.payType = sender.tag;
    
    if (self.payType == 4) {
        self.price = @"";
        [self getApplePayMoneyData];
        self.customV.hidden = YES;
        
    } else {
        [self getMoneyData];
        self.customV.hidden = NO;
    }
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
            [argument setValue:@0 forKey:@"pay_type"];
        }
            break;
            
        case 1: {
            [argument setValue:@1 forKey:@"pay_type"];
        }
            break;
            
        case 2: {
            [argument setValue:@4 forKey:@"pay_type"];
        }
            break;
            
        case 3: {
            [argument setValue:@3 forKey:@"pay_type"];
        }
            break;
            
        case 4: {
            [argument setValue:@2 forKey:@"pay_type"];
        }
            break;
            
        default:
            break;
    }
    
    if (self.payType == 0) { // 微信支付
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = @"gh_c1dbf3d659ae";
        launchMiniProgramReq.path = [NSString stringWithFormat:@"pages/index/index?pay_type=0&price=%@&token=%@", self.price, NAppManager.token];
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease;
        [WXApi sendReq:launchMiniProgramReq completion:nil];
        [FFPopup dismissAllPopups];
        return;
    }
    
    
    @weakify(self)
    [NYSNetRequest jsonNoCheckNetworkRequestWithType:POST
                                                   url:@"/index/Order/create"
                                              parameters:argument
                                                remark:@"下单调起支付"
                                               success:^(id response) {
        @strongify(self)
        if (self.payType == 4) {
            if ([response[@"code"] intValue] == 200) {
                self.orderNo = [response stringValueForKey:@"data" default:@""];
                [self.appStorePay starBuyToAppStore:self.applePayId];
                
            } else {
                [NYSTools showToast:response[@"msg"]];
            }
            return;
        }
    
        
        if ([response[@"status"] isEqual:@"succeeded"]) {
            if (self.payType == 0) {
                
            } else if (self.payType == 1) {
                self.payAlertView.subtitleL.text = self.isRecharge ? @"请在支付宝支付完成后，\n返回APP确认金币到账情况" : @"在支付宝完成充值后\n返回app进行购买";
                self.payAlertView.block = ^(id obj) {
                    @strongify(self)
                    if ([obj isEqual:@"1"]) {
                        SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:response[@"expend"][@"pay_info"]]];
                        [self.superVC presentViewController:sfVC animated:YES completion:nil];
                        [FFPopup dismissAllPopups];
                    } else {
                        [FFPopup dismissSuperPopupIn:self.payAlertView animated:YES];
                    }
                };
                FFPopup *popup = [FFPopup popupWithContentView:self.payAlertView showType:FFPopupShowType_BounceIn dismissType:FFPopupDismissType_ShrinkOut maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
                FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Center, FFPopupVerticalLayout_Center);
                [popup showWithLayout:layout];
                
            } else if (self.payType == 2) {
                SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:response[@"data"][@"url"]]];
                [self.superVC presentViewController:sfVC animated:YES completion:nil];
                [FFPopup dismissAllPopups];
                
            } else if (self.payType == 3) {
                
            } else if (self.payType == 4) {
                
            }
            
        } else {
            NSString *msg = [response stringValueForKey:@"error_msg" default:@""];
            if (![msg isNotBlank]) {
                msg = [response stringValueForKey:@"msg" default:@""];
            }
            [NYSTools showToast:msg];
            [NYSTools dismissWithDelay:1.f completion:^{
                if ([msg containsString:@"登录"])
                    [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationTokenInvalidation object:response[@"msg"]];
            }];
        }
        
    } failed:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - EMAppStorePayDelegate
- (void)EMAppStorePay:(EMAppStorePay *)appStorePay responseAppStorePaySuccess:(NSDictionary *)dicValue error:(NSError*)error {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    [argument setValue:self.orderNo forKey:@"order_no"];
    [argument setValue:dicValue[@"value"] forKey:@"receipt"];
#ifdef DEBUG
    [argument setValue:@(true) forKey:@"sandbox"];
#else
    [argument setValue:@(false) forKey:@"sandbox"];
#endif
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                                   url:@"/index/Adapay/ios_notify"
                                              parameters:argument
                                                remark:@"校验内购支付结果"
                                        success:^(NSDictionary * _Nullable response) {
        [NYSTools showToast:@"充值成功"];
        [FFPopup dismissAllPopups];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (NAppManager.isLogined)
                [NAppManager loadUserInfoCompletion:nil];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadWalletListData" object:nil];
        
    } failed:^(NSError * _Nullable error) {
        
    }];
}


- (NYSPayAlertView *)payAlertView {
    if (!_payAlertView) {
        _payAlertView = [[NYSPayAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.65, RealValue(180))];
    }
    return _payAlertView;
}

- (EMAppStorePay *)appStorePay {
    if (!_appStorePay) {
        _appStorePay = [[EMAppStorePay alloc] init];
        _appStorePay.delegate = self;
    }
    return _appStorePay;
}

@end
