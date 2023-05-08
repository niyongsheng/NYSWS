//
//  NYSLoginVC.m
//  LKBusinessCollege
//
//  Created by niyongsheng.github.io on 2022/7/29.
//  Copyright © 2022 NYS. ALL rights reserved.
//

#import "NYSLoginVC.h"
#import "NYSForgetPwdVC.h"
#import "NYSRegisterVC.h"

@interface NYSLoginVC () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *onceCodeTF;
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
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = UIColor.whiteColor;
    self.scrollV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    
    
    ViewRadius(_loginBtn, 22.5f)
    if (!isIphonex) {
        self.top.constant = - NStatusBarHeight;
    }
    
    self.accountTF.maxLength = 11;
    self.onceCodeTF.maxLength = 6;
    
    self.accountTF.delegate = self;
    self.onceCodeTF.delegate = self;
    
    [self check];
    
    // 协议富文本
    NSString *protocolStr = @"我已阅读并同意《服务协议》、《隐私政策》"; //@"阅读并同意《隐私政策》";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:UIColor.grayColor range:[protocolStr rangeOfString:protocolStr]];
    
    NSRange range2 = [protocolStr rangeOfString:@"《服务协议》"];
    NSRange range3 = [protocolStr rangeOfString:@"《隐私政策》"];

    [attString addAttribute:NSLinkAttributeName value:@"user://" range:range2];
    [attString addAttribute:NSLinkAttributeName value:@"privacy://" range:range3];
    
    _protocolT.linkTextAttributes = @{NSForegroundColorAttributeName:NAppThemeColor};
    [_protocolT setDelegate:self];
    [_protocolT setAttributedText:attString];
    
#ifdef DEBUG
    _accountTF.text = @"15254998038";
    _onceCodeTF.text = @"123456";
#endif
}

- (IBAction)registerBtnOnclicked:(UIButton *)sender {
    [self.navigationController pushViewController:NYSRegisterVC.new animated:YES];
}

- (IBAction)forgetBtnOnclicked:(UIButton *)sender {
    [self.navigationController pushViewController:NYSForgetPwdVC.new animated:YES];
}

/// 登录
/// @param sender btn
- (IBAction)loginBtnOnclicked:(UIButton *)sender {
    [self.view endEditing:YES];

    if (![_accountTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入手机号码"];
        [NYSTools shakToShow:sender];
        return;
    }
    
    if (![_onceCodeTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入验证码"];
        [NYSTools shakToShow:sender];
        return;
    }
    
    if (!self.protocolBtn.selected) {
        [NYSTools showToast:@"请勾选协议"];
        [NYSTools shakToShow:self.protocolBtn];
        return;
    }
    
    
    [NYSTools zoomToShow:sender];
    NSDictionary *argument = @{@"phone": _accountTF.text,
                               @"code": _onceCodeTF.text,
    };
//    NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodPOST
//                                                         url:POST_SMSLogin
//                                                    argument:argument
//                                       requestSerializerType:YTKRequestSerializerTypeJSON
//                                                      remark:@"登录"];
//
//    [request requestSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        [NUserManager loginHandler:NUserLoginTypePwd
//                         tokenInfo:request.responseJSONObject
//                        completion:^(BOOL success, id obj) {
//
//            if (success) {
//                [NYSTools showIconToast:obj isSuccess:YES offset:UIOffsetMake(0, 0)];
//                [SVProgressHUD dismissWithDelay:0.5f completion:^{
//                    NPostNotification(NNotificationLoginStateChange, @YES)
//                }];
//
//            } else {
//                [SVProgressHUD showInfoWithStatus:obj];
//                [SVProgressHUD dismissWithDelay:1.f];
//            }
//        }];
//
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//    }];
}

- (IBAction)codeOnclicked:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![_accountTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入手机号码"];
        return;
    }
    
    WS(weakSelf)
    NSDictionary *argument = @{@"phone": _accountTF.text};
//    NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodPOST
//                                                         url:GET_CaptchaSMS
//                                                    argument:argument
//                                       requestSerializerType:YTKRequestSerializerTypeJSON
//                                                      remark:@"获取短信验证码"];
//    [request requestSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        [NYSTools showToast:@"验证码已发送，请注意查收"];
//        weakSelf.accountTF.enabled = NO;
//
//        weakSelf.onceCodeBtn.userInteractionEnabled = NO;
//        weakSelf.secondsCountDownInput = 1*60;
//        weakSelf.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(timerTriggerMethon) userInfo:nil repeats:YES];
//
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//    }];
}

- (void)timerTriggerMethon {
    self.secondsCountDownInput --;

}

- (IBAction)wcBtnOnclicked:(UIButton *)sender {
    
}


- (IBAction)protocolBtnOnclicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark 富文本点击事件
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"user"]) {
        NYSWebViewController *webVC = [NYSWebViewController new];
        webVC.urlStr = AppServiceAgreement;
        webVC.title = @"服务协议";
        webVC.autoTitle = NO;
        [self.navigationController pushViewController:webVC animated:YES];
        
    } else {
        
        NYSWebViewController *webVC = [NYSWebViewController new];
        webVC.urlStr = AppPrivacyAgreement;
        webVC.title = @"隐私协议";
        webVC.autoTitle = NO;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [self check];
}

- (void)check {
    if (self.accountTF.text.length == 11 && self.onceCodeTF.text.length >= 6) {
        [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:NAppThemeColor];
        [self.loginBtn setEnabled:YES];
    
    } else {
        [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        [self.loginBtn setEnabled:NO];
    }
}

@end
