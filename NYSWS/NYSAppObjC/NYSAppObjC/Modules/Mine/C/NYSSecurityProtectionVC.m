//
//  NYSUpdateInfoVC.m
//  LKXiaoLuZSB
//
//  Created by niyongsheng on 2022/9/28.
//  Copyright © 2022 niyongsheng. All rights reserved.
//

#import "NYSSecurityProtectionVC.h"

@interface NYSSecurityProtectionVC ()
{
    NSString *_iconUrl;
}

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation NYSSecurityProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NLocalizedStr(@"SecurityQuestion");

    ViewRadius(_commitBtn, 22.5f)
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    self.nameL.text = NAppManager.userInfo.security_question;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    if (![_nameTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsSecurityQuestionAnswer")];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"phone": NAppManager.userInfo.phone,
        @"security_answer": _nameTF.text,
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Member/confirm_security"
                                      argument:params
                                             remark:@"验证密保答案"
                                            success:^(id response) {
        @strongify(self)
        [NYSTools showIconToast:NLocalizedStr(@"PassVerification") isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(NSError * _Nullable error) {


    }];
}


@end
