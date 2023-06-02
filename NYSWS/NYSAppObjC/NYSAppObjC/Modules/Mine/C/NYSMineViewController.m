//
//  NYSMineViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.

#import "NYSMineViewController.h"

#import "NYSUpdateInfoVC.h"
#import "NYSSettingViewController.h"
#import "NYSCallCenterVC.h"
#import "NYSMessageCenterVC.h"
#import "NYSHelpViewController.h"
#import "NYSAboutViewController.h"
#import "NYSWalletViewController.h"
#import "NYSSecurityProtectionVC.h"
#import "NYSFeedbackVC.h"
#import "NYSMyCourseListPagingVC.h"
#import "NYSRecommendVC.h"
#import "NYSRechargeAlertView.h"

@interface NYSMineViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@property (weak, nonatomic) IBOutlet UIView *headerBgV;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *coinL;
@property (weak, nonatomic) IBOutlet UIView *rechargeV;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemTwoBtn;

@property (weak, nonatomic) IBOutlet UIView *functionV;
@property (weak, nonatomic) IBOutlet UIView *mineV;

@property (strong, nonatomic) NYSRechargeAlertView *rechargeAlertView;
@end

@implementation NYSMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 刷新UI
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NNotificationReloadUserDetailInfo object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [self updateUserInfo:NAppManager.userInfo];
    }];
    
    [self wr_setNavBarBackgroundAlpha:0];
    self.contentViewTop.constant -= NTopHeight;
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 280)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 280)];
    [path addQuadCurveToPoint:CGPointMake(0, 280) controlPoint:CGPointMake(kScreenWidth/2, 300)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, kScreenWidth, 300);
    layer.path = path.CGPath;
    _headerBgV.layer.mask = layer;
    
    // 渐变背景色
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = layer.frame;
//    gl.startPoint = CGPointMake(0, 0);
//    gl.endPoint = CGPointMake(1, 1);
//    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF8648"].CGColor,
//                  (__bridge id)[UIColor colorWithHexString:@"#FA8632"].CGColor,
//                  (__bridge id)[UIColor colorWithHexString:@"#F88641"].CGColor];
//    gl.locations = @[@(0.0),@(0.8),@(1.0)];
//    [_headerBgV.layer addSublayer:gl];
    
    ViewBorderRadius(_iconIV, 40, 1, UIColor.whiteColor);
    ViewRadius(_rechargeV, 17.5);
    ViewRadius(_rechargeBtn, 12.5);
    ViewRadius(_itemOneBtn, 13);
    ViewRadius(_itemTwoBtn, 13);
    ViewRadius(_functionV, 10);
    ViewRadius(_mineV, 10);
    self.coinL.adjustsFontSizeToFitWidth = YES;
    
    NAppManager.isLogined ? [self updateUserInfo:NAppManager.userInfo] : nil;
}

- (void)updateUserInfo:(NYSUserInfo *)userInfo {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.coinL.text = userInfo.balance;
        self.nicknameL.text = userInfo.nickname;
        self.phoneL.text = [NYSTools phoneStringAsteriskHandle:userInfo.phone];
        
        [self.iconIV setImageWithURL:NCDNURL(userInfo.avatar) placeholder:[UIImage imageNamed:@"icon_test_pass"]];
    });
}

- (IBAction)headerBtnOnclicked:(UIButton *)sender {
    if (sender.tag == 11) {
        [self.navigationController pushViewController:NYSUpdateInfoVC.new animated:YES];
        
    } else if (sender.tag == 22) {
        [NYSTools zoomToShow:sender.layer];
        
        // 充值弹框
        @weakify(self)
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
        
    } else if (sender.tag == 1) {
        [self.navigationController pushViewController:NYSMyCourseListPagingVC.new animated:YES];
        
    } else if (sender.tag == 2) {
        [self.navigationController pushViewController:NYSRecommendVC.new animated:YES];
    }
}

- (IBAction)functionBtnOnclicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1: {
            [self.navigationController pushViewController:NYSWalletViewController.new animated:YES];
        }
            break;
            
        case 2: {
            [self.navigationController pushViewController:NYSHelpViewController.new animated:YES];
        }
            break;
            
        case 3: {
            [self.navigationController pushViewController:NYSMessageCenterVC.new animated:YES];
        }
            break;
            
        case 4: {
            [self.navigationController pushViewController:NYSCallCenterVC.new animated:YES];
        }
            break;
            
        case 5: {
            [self.navigationController pushViewController:NYSSettingViewController.new animated:YES];
        }
            break;
            
        case 6: {
            [self.navigationController pushViewController:NYSFeedbackVC.new animated:YES];
        }
            break;
            
        case 7: {
            [self.navigationController pushViewController:NYSAboutViewController.new animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)otherBtnOnclicked:(UIButton *)sender {
    if (sender.tag == 1) {
        
        SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:HLWMUrl]];
        [self presentViewController:sfVC animated:YES completion:nil];
        
    } else {
        [self.navigationController pushViewController:NYSBaseViewController.new animated:YES];
    }
}

#pragma mark - 充值
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
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = response[@"partnerId"];
                request.prepayId = response[@"prepayId"];
                request.package = @"Sign=WXPay";
                request.nonceStr = response[@"nonceStr"];
                request.timeStamp = [NYSTools getNowTimeTimestamp].unsignedIntValue;
                request.sign = response[@"sign"];
                [WXApi sendReq:request];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NLocalizedStr(@"Tips") message:NLocalizedStr(@"UninstallWechat") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NLocalizedStr(@"OK") style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } else if ([obj[@"pay_type"] intValue] == 1) {
            NSString *url = [NSString stringWithFormat:@"alipay://%@", response];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
            if (canOpen) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NLocalizedStr(@"Tips") message:NLocalizedStr(@"UninstallAlipay") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NLocalizedStr(@"OK") style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        

    } failed:^(NSError * _Nullable error) {
        
    }];
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
