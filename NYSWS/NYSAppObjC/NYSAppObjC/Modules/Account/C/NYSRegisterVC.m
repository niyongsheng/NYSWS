//
//  NYSRegisterVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSRegisterVC.h"
#import "NYSProtocolDetailVC.h"

@interface NYSRegisterVC () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *securityQuestionTF;
@property (weak, nonatomic) IBOutlet UITextField *securityAnswerTF;
@property (weak, nonatomic) IBOutlet UITextField *InvitationCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UITextView *protocolT;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = NLocalizedStr(@"Regist");
    
    ViewRadius(_commitBtn, 22.5f)
    
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
    
    // 获取剪贴板中的邀请码
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError *error = nil;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *jsonStr = pasteboard.string;
        if ([jsonStr isNotBlank]) {
            NSData *jsonData = [pasteboard.string dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (!error && [dictionary[@"code"] isNotBlank]) {
                self.InvitationCodeTF.text = dictionary[@"code"];
                self.InvitationCodeTF.enabled = NO;
            }
        }
    });
}

- (IBAction)securityQuestionBtnOnclicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc] init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = NLocalizedStr(@"SecurityQuestionTitle");
    stringPickerView.dataSourceArr = @[
        NLocalizedStr(@"SecurityQuestion1"),
        NLocalizedStr(@"SecurityQuestion2"),
        NLocalizedStr(@"SecurityQuestion3"),
        NLocalizedStr(@"SecurityQuestion4"),
        NLocalizedStr(@"SecurityQuestion5"),
    ];
    stringPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        self.securityQuestionTF.text = resultModel.value;
    };
    
    // 设置自定义样式
    UIColor *color = NAppThemeColor;
    BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:color];
    customStyle.selectRowTextColor = color;
    customStyle.topCornerRadius = 1.5*NRadius;
    stringPickerView.pickerStyle = customStyle;
    
    [stringPickerView show];
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

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self.nicknameTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsLoginName")];
        [NYSTools shakeAnimation:self.nicknameTF.layer];
        return;
    }
    
    if (self.nicknameTF.text.length < 1 || self.nicknameTF.text.length > 13) {
        [NYSTools showToast:NLocalizedStr(@"TipsNicknameLength")];
        [NYSTools shakeAnimation:self.nicknameTF.layer];
        return;
    }
    
//    if (![self.phoneTF.text isNotBlank]) {
//        [NYSTools showToast:NLocalizedStr(@"TipsPhone")];
//        [NYSTools shakeAnimation:self.phoneTF.layer];
//        return;
//    }
//
//    if (self.phoneTF.text.length != 11) {
//        [NYSTools showToast:NLocalizedStr(@"TipsPhoneFormat")];
//        [NYSTools shakeAnimation:self.phoneTF.layer];
//        return;
//    }
    
    if (![self.passwordTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"PlaceholderPwd")];
        [NYSTools shakeAnimation:self.passwordTF.layer];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 16) {
        [NYSTools showToast:NLocalizedStr(@"TipsPwdLength")];
        [NYSTools shakeAnimation:self.passwordTF.layer];
        return;
    }
    
    if (![self.repasswordTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsRepwd")];
        [NYSTools shakeAnimation:self.repasswordTF.layer];
        return;
    }
    
    if (![self.repasswordTF.text isEqualToString:self.passwordTF.text]) {
        [NYSTools showToast:NLocalizedStr(@"TipsRepwdError")];
        [NYSTools shakeAnimation:self.passwordTF.layer];
        [NYSTools shakeAnimation:self.repasswordTF.layer];
        return;
    }
    
    if (![self.securityQuestionTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsSecurityQuestion")];
        [NYSTools shakeAnimation:self.securityQuestionTF.layer];
        return;
    }
    
    if (![self.securityAnswerTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsSecurityQuestionAnswer")];
        [NYSTools shakeAnimation:self.securityAnswerTF.layer];
        return;
    }
    
//    if (![self.InvitationCodeTF.text isNotBlank]) {
//        [NYSTools showToast:NLocalizedStr(@"TipsInviteCode")];
//        [NYSTools shakeAnimation:self.InvitationCodeTF.layer];
//        return;
//    }
    
    if (!self.protocolBtn.selected) {
        [NYSTools showToast:NLocalizedStr(@"TipsProtocol")];
        [NYSTools shakToShow:self.protocolBtn];
        return;
    }
    
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    argument[@"nickname"] = _nicknameTF.text;
    argument[@"phone"] = _phoneTF.text;
    argument[@"password"] = _passwordTF.text;
    argument[@"security_question"] = _securityQuestionTF.text;
    argument[@"security_answer"] = _securityAnswerTF.text;
    argument[@"Invitation_code"] = _InvitationCodeTF.text;
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/register"
                                       parameters:argument
                                         remark:@"注册"
                                        success:^(id response) {
        @strongify(self)
        [NYSTools showIconToast:NLocalizedStr(@"RegistSuccess") isSuccess:YES offset:UIOffsetMake(0, 0)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    } failed:^(NSError * _Nullable error) {

    }];
}

- (IBAction)protocolBtnOnclicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
