//
//  NYSResetPwdVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSResetPwdVC.h"
#import "NYSConsultVC.h"

@interface NYSResetPwdVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *securityQuestionTF;
@property (weak, nonatomic) IBOutlet UITextField *securityAnswerTF;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = NLocalizedStr(@"ForgetPwd");
    
    ViewRadius(_commitBtn, 22.5f)
    self.nicknameTF.delegate = self;
}

- (IBAction)securityQuestionBtnOnclicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
//    if (self.nicknameTF.text.length != 11) {
//        [NYSTools showToast:NLocalizedStr(@"TipsPhoneFormat")];
//        [NYSTools shakeAnimation:self.nicknameTF.layer];
//        return;
//    }
    
    [self textFieldDidChangeSelection:self.nicknameTF];
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
    
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    argument[@"nickname"] = _nicknameTF.text;
    argument[@"security_question"] = _securityQuestionTF.text;
    argument[@"security_answer"] = _securityAnswerTF.text;
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/confirm_security"
                                       parameters:argument
                                         remark:@"验证密保答案"
                                        success:^(id response) {
        @strongify(self)
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"nickname"] = self.nicknameTF.text;
        params[@"password"] = self.passwordTF.text;
        [NYSNetRequest jsonNetworkRequestWithType:POST
                                                url:@"/index/Member/update_pass"
                                           parameters:params
                                             remark:@"重置密码"
                                            success:^(id response) {
            @strongify(self)
            [NYSTools showIconToast:NLocalizedStr(@"ResetSuccess") isSuccess:YES offset:UIOffsetMake(0, 0)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        } failed:^(NSError * _Nullable error) {

        }];

    } failed:^(NSError * _Nullable error) {

    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if ([textField.text isNotBlank]) {
        self.securityQuestionTF.text = @"";
    }
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/confidentiality"
                                       parameters:@{@"nickname" : textField.text}
                                         remark:@"获取密保问题"
                                        success:^(id response) {
        @strongify(self)
        if ([response[@"security_question"] isNotBlank]) {
            self.securityQuestionTF.text = response[@"security_question"];
        }
        
    } failed:^(NSError * _Nullable error) {
        
    }];
}

- (IBAction)consultBtnOnclicked:(UIButton *)sender {
    [self.navigationController pushViewController:NYSConsultVC.new animated:YES];
}

@end
