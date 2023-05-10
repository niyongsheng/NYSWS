//
//  NYSRegisterVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSRegisterVC.h"

@interface NYSRegisterVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *securityQuestionTF;
@property (weak, nonatomic) IBOutlet UITextField *securityAnswerTF;
@property (weak, nonatomic) IBOutlet UITextField *InvitationCodeTF;



@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
    ViewRadius(_commitBtn, 22.5f)
    
#ifdef DEBUG
    _nicknameTF.text = @"Testing";
    _phoneTF.text = @"18888888888";
    _passwordTF.text = @"abcd1234";
    _repasswordTF.text = @"abcd1234";
    _securityQuestionTF.text = @"how are you";
    _securityAnswerTF.text = @"fine";
    _InvitationCodeTF.text = @"123";
#endif
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    if (![self.nicknameTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入登录名"];
        [NYSTools shakeAnimation:self.nicknameTF.layer];
        return;
    }
    
    if (![self.phoneTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入手机号"];
        [NYSTools shakeAnimation:self.phoneTF.layer];
        return;
    }
    
    if (self.phoneTF.text.length != 11) {
        [NYSTools showToast:@"请输入格式正确的手机号"];
        [NYSTools shakeAnimation:self.phoneTF.layer];
        return;
    }
    
    if (![self.passwordTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入密码"];
        [NYSTools shakeAnimation:self.passwordTF.layer];
        return;
    }
    
    if (![self.repasswordTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入重复密码"];
        [NYSTools shakeAnimation:self.repasswordTF.layer];
        return;
    }
    
    if (![self.repasswordTF.text isEqualToString:self.passwordTF.text]) {
        [NYSTools showToast:@"两次密码不一致"];
        [NYSTools shakeAnimation:self.passwordTF.layer];
        [NYSTools shakeAnimation:self.repasswordTF.layer];
        return;
    }
    
    if (![self.securityQuestionTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入密保问题"];
        [NYSTools shakeAnimation:self.securityQuestionTF.layer];
        return;
    }
    
    if (![self.securityAnswerTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入密保答案"];
        [NYSTools shakeAnimation:self.securityAnswerTF.layer];
        return;
    }
    
//    if (![self.InvitationCodeTF.text isNotBlank]) {
//        [NYSTools showToast:@"请输入邀请码"];
//        [NYSTools shakeAnimation:self.InvitationCodeTF.layer];
//        return;
//    }
    
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    argument[@"nickname"] = _nicknameTF.text;
    argument[@"phone"] = _phoneTF.text;
    argument[@"password"] = _passwordTF.text;
    argument[@"security_question"] = _securityQuestionTF.text;
    argument[@"security_answer"] = _securityAnswerTF.text;
    argument[@"Invitation_code"] = _InvitationCodeTF.text;
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/register"
                                       argument:argument
                                         remark:@"注册"
                                        success:^(id response) {
        @strongify(self)
        [NYSTools showIconToast:@"注册成功" isSuccess:YES offset:UIOffsetMake(0, 0)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    } failed:^(NSError * _Nullable error) {

    }];
}

@end
