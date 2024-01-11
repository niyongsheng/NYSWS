//
//  NYSCourseExchangeVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCoursePurchaseVC.h"
#import "NYSRechargeAlertView.h"

@interface NYSCoursePurchaseVC ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *coinL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;

@property (weak, nonatomic) IBOutlet UIButton *payTypeBtn0;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) NYSRechargeAlertView *rechargeAlertView;
@end

@implementation NYSCoursePurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"Pay");
    [self wr_setNavBarBarTintColor:NAppThemeColor];
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    
    self.view.backgroundColor = NAppThemeColor;
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    ViewRadius(_contentV, 30);
    ViewRadius(_commitBtn, 22.5);
    self.timeL.adjustsFontSizeToFitWidth = YES;
    self.infoL.adjustsFontSizeToFitWidth = YES;
    self.subtitleL.adjustsFontSizeToFitWidth = YES;

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.payTypeBtn0.selected = YES;
    
    [self.iconIV setImageWithURL:NCDNURL(self.detailModel.image) placeholder:NPImageFillet];
    self.titleL.text = self.detailModel.name;
    self.subtitleL.text = self.detailModel.subtitle;
    self.coinL.text = self.detailModel.price;
    self.timeL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"UpdateTime"), [NYSTools transformTimestampToTime:self.detailModel.updatetime * 1000 format:nil]];
    self.infoL.text = [NSString stringWithFormat:@"%@：%.2fMB   %@：%@",
                       NLocalizedStr(@"CourseSize"), self.detailModel.size, NLocalizedStr(@"CourseVersion"), self.detailModel.version];
    self.balanceL.text = [NSString stringWithFormat:@"%@%.2f", NLocalizedStr(@"MyBalance"), NAppManager.userInfo.balance.floatValue];
    
    // 更新余额
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NNotificationReloadUserDetailInfo object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.balanceL.text = [NSString stringWithFormat:@"%@%.2f", NLocalizedStr(@"MyBalance"), NAppManager.userInfo.balance.floatValue];
        });
    }];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    
    NSMutableDictionary *params = @{
        @"course_id": @(self.detailModel.ID)
    }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNoCheckNetworkRequestWithType:POST
                                                   url:@"/index/Course/purchase"
                                              parameters:params
                                                remark:@"购买课程"
                                               success:^(id response) {
        NSString *msg = [response stringValueForKey:@"msg" default:@""];
        if ([response[@"code"] integerValue] == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadData" object:nil];
            
            @strongify(self)
            NYSAlertView *alertView = [[NYSAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.75, RealValue(220))];
            alertView.cancelBtn.hidden = YES;
            alertView.titleL.text = NLocalizedStr(@"BuySuccess");
            alertView.block = ^(id obj) {
                [FFPopup dismissAllPopups];
                
                if ([obj isEqual:@"1"]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            };
            FFPopup *popup = [FFPopup popupWithContentView:alertView showType:FFPopupShowType_BounceIn dismissType:FFPopupDismissType_ShrinkOut maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
            FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Center, FFPopupVerticalLayout_Center);
            [popup showWithLayout:layout];
            
            // 更新缓存
            [NAppManager cacheAudioData:YES isRecache:YES];
            
        } else {
            [NYSTools showToast:msg];
            [NYSTools dismissWithDelay:1.f completion:^{
                if ([msg containsString:@"余额不足"]) {
                    // 充值弹框
                    self.rechargeAlertView.superVC = self;
                    FFPopup *popup = [FFPopup popupWithContentView:self.rechargeAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
                    FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
                    [popup showWithLayout:layout];
                    
                } else if ([msg containsString:@"登录"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationTokenInvalidation object:response[@"msg"]];
                }
            }];
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

