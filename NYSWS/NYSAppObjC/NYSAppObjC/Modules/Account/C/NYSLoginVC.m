//
//  NYSLoginVC.m
//  LKBusinessCollege
//
//  Created by niyongsheng.github.io on 2022/7/29.
//  Copyright © 2022 NYS. ALL rights reserved.
//

#import "NYSLoginVC.h"
#import "NYSResetPwdVC.h"
#import "NYSRegisterVC.h"
#import "NYSProtocolDetailVC.h"
#import "NYSAgrementAlertView.h"

@interface NYSLoginVC () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UITextView *protocolT;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (nonatomic,assign) NSInteger secondsCountDownInput;
@property (nonatomic,strong) NSTimer *countDownTimer;

@end

@implementation NYSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = NO;
    self.navigationItem.title = NLocalizedStr(@"Login");
    self.view.backgroundColor = UIColor.whiteColor;
    self.scrollV.backgroundColor = UIColor.whiteColor;
    self.scrollV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    
    
    ViewRadius(_loginBtn, 22.5f)
    if (!isIphonex) {
        self.top.constant = - NStatusBarHeight;
    }
    
    self.accountTF.maxLength = 15;
    self.passwordTF.maxLength = 20;
    
    self.accountTF.delegate = self;
    self.passwordTF.delegate = self;
    
    [self check];
    
    // 协议富文本
    NSString *protocolStr = NLocalizedStr(@"ProtocolDesc"); //@"阅读并同意《隐私政策》";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:UIColor.grayColor range:[protocolStr rangeOfString:protocolStr]];
    [attString addAttribute:(NSString*)NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[protocolStr rangeOfString:protocolStr]];
    
    NSRange range2 = [protocolStr rangeOfString:NLocalizedStr(@"UserProtocol")];
    NSRange range3 = [protocolStr rangeOfString:NLocalizedStr(@"PrivacyProtocol")];
    
    [attString addAttribute:NSLinkAttributeName value:@"user://" range:range2];
    [attString addAttribute:NSLinkAttributeName value:@"privacy://" range:range3];
    
    _protocolT.linkTextAttributes = @{NSForegroundColorAttributeName:NAppThemeColor};
    [_protocolT setDelegate:self];
    [_protocolT setAttributedText:attString];
    
#ifdef DEBUG
    _accountTF.text = @"";
    _passwordTF.text = @"";
    
    [self check];
    [self.view endEditing:YES];
    self.protocolBtn.selected = YES;
#else
    // 自动填充上次登录成功的账号密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _accountTF.text = [defaults objectForKey:@"app.username"];
    _passwordTF.text = [defaults objectForKey:@"app.password"];
#endif
}

- (IBAction)registerBtnOnclicked:(UIButton *)sender {
    [self.navigationController pushViewController:NYSRegisterVC.new animated:YES];
}

- (IBAction)forgetBtnOnclicked:(UIButton *)sender {
    [self.navigationController pushViewController:NYSResetPwdVC.new animated:YES];
}

/// 登录
/// @param sender btn
- (IBAction)loginBtnOnclicked:(UIButton *)sender {
    [self.view endEditing:YES];

    if (![_accountTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"PlaceholderAccout")];
        [NYSTools shakToShow:sender];
        return;
    }
    
    if (![_passwordTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"PlaceholderPwd")];
        [NYSTools shakToShow:sender];
        return;
    }
    
    [NYSTools zoomToShow:sender.layer];
    if (!self.protocolBtn.selected) {
        
        @weakify(self)
        NYSAgrementAlertView *alertView = [[NYSAgrementAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.75, RealValue(220))];
        alertView.block = ^(id obj) {
            @strongify(self)
            [FFPopup dismissAllPopups];
            
            if ([obj isEqual:@"1"]) {
                self.protocolBtn.selected = YES;
                [self loginBtnOnclicked:[UIButton new]];
            }
        };
        FFPopup *popup = [FFPopup popupWithContentView:alertView showType:FFPopupShowType_BounceIn dismissType:FFPopupDismissType_ShrinkOut maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
        FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Center, FFPopupVerticalLayout_Center);
        [popup showWithLayout:layout];
        
//        [NYSTools showToast:NLocalizedStr(@"TipsProtocol")];
//        [NYSTools shakToShow:self.protocolBtn];
        return;
    }
    
    NSDictionary *argument = @{@"username": _accountTF.text,
                               @"password": _passwordTF.text,
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/login"
                                       parameters:argument
                                         remark:@"登录"
                                        success:^(id response) {
        @strongify(self)
        [NAppManager loginHandler:NUserLoginTypePwd authInfo:[NYSAuthInfo modelWithDictionary:@{@"token" : response}] completion:^(BOOL success, id obj) {
            if (success) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:argument[@"username"] forKey:@"app.username"];
                [defaults setObject:argument[@"password"] forKey:@"app.password"];
                [defaults synchronize];
                
                [NYSTools showIconToast:NLocalizedStr(@"LoginSuccess") isSuccess:YES offset:UIOffsetMake(0, 0)];
                [NYSTools dismissWithCompletion:^{
                    NPostNotification(NNotificationLoginStateChange, @YES)
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    });
                }];
            }
        }];

    } failed:^(NSError * _Nullable error) {

    }];
}

- (IBAction)protocolBtnOnclicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark 富文本点击事件
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"user"]) {
        @weakify(self)
        [NYSNetRequest jsonNetworkRequestWithType:POST
                                                url:@"/index/Member/get_user_agreement"
                                           parameters:nil
                                             remark:@"服务协议"
                                            success:^(id response) {
            @strongify(self)
            NYSProtocolDetailVC *detailVC = [NYSProtocolDetailVC new];
            detailVC.contentStr = [response stringValueForKey:@"value" default:AppServiceAgreement];
            detailVC.title = NLocalizedStr(@"UserProtocol");
            [self.navigationController pushViewController:detailVC animated:YES];

        } failed:^(NSError * _Nullable error) {

        }];
        
    } else {
        @weakify(self)
        [NYSNetRequest jsonNetworkRequestWithType:POST
                                                url:@"/index/Member/get_privacy_agreement"
                                           parameters:nil
                                             remark:@"隐私协议"
                                            success:^(id response) {
            @strongify(self)
            NYSProtocolDetailVC *detailVC = [NYSProtocolDetailVC new];
            detailVC.contentStr = [response stringValueForKey:@"value" default:AppServiceAgreement];
            detailVC.title = NLocalizedStr(@"PrivacyProtocol");
            [self.navigationController pushViewController:detailVC animated:YES];

        } failed:^(NSError * _Nullable error) {

        }];
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [self check];
}

- (void)check {
    [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    [self.loginBtn setBackgroundColor:NAppThemeColor];
    [self.loginBtn setEnabled:YES];
    
//    if (self.accountTF.text.length >= 4 && self.passwordTF.text.length >= 6) {
//        [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [self.loginBtn setBackgroundColor:NAppThemeColor];
//        [self.loginBtn setEnabled:YES];
//
//    } else {
//        [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
//        [self.loginBtn setEnabled:NO];
//    }
}

@end
