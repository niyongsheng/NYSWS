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
    
    NAppManager.isLogined ? [NAppManager loadUserInfoCompletion:nil] : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NNotificationReloadUserDetailInfo object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        // 更新用户信息UI
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
    
    [self updateUserInfo:NAppManager.userInfo];
}

- (void)updateUserInfo:(NYSUserInfo *)userInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (NAppManager.isLogined) {
            self.coinL.text = userInfo.balance;
            self.nicknameL.text = userInfo.nickname;
            self.phoneL.text = [NYSTools phoneStringAsteriskHandle:userInfo.phone];
            [self.iconIV setImageWithURL:NCDNURL(userInfo.avatar) placeholder:[UIImage imageNamed:@"icon_test_pass"]];
        } else {
            self.nicknameL.text = NLocalizedStr(@"Unlogin");
            self.headerBgV.userInteractionEnabled = YES;
            [self.headerBgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                NPostNotification(NNotificationLoginStateChange, @NO)
            }]];
        }
    });
}

- (IBAction)headerBtnOnclicked:(UIButton *)sender {
    if (sender.tag == 11) {
        if (!NAppManager.isLogined)
            NPostNotification(NNotificationLoginStateChange, @NO)
            
        [self.navigationController pushViewController:NYSUpdateInfoVC.new animated:YES];
        
    } else if (sender.tag == 22) {
        [NYSTools zoomToShow:sender.layer];
        
        // 充值弹框
        self.rechargeAlertView.superVC = self;
        FFPopup *popup = [FFPopup popupWithContentView:self.rechargeAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
        FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
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
            if (!NAppManager.isLogined)
                NPostNotification(NNotificationLoginStateChange, @NO)
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
        
        NYSWebViewController *webVC = [NYSWebViewController new];
        webVC.autoTitle = YES;
        webVC.urlStr = NYSPagesUrl;
        [self.navigationController pushViewController:webVC animated:YES];
        
    } else {
        
        NYSWebViewController *webVC = [NYSWebViewController new];
        webVC.autoTitle = YES;
        webVC.urlStr = NYSPagesUrl;
        [self.navigationController pushViewController:webVC animated:YES];
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

@end
