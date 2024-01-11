//
//  NYSResetPwdViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/11.
//

#import "NYSResetPwdViewController.h"

@interface NYSResetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *freshPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *renewPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"ModifyPassword");

    ViewRadius(_commitBtn, 22.5f)
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    if (![_pwdTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsOldPwd")];
        return;
    }
    
    if (![_freshPwdTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsNewPwd")];
        return;
    }
    
    if (![_renewPwdTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsRepwd")];
        return;
    }
    
    if (![_freshPwdTF.text isEqualToString:_renewPwdTF.text]) {
        [NYSTools showToast:NLocalizedStr(@"TipsRepwdError")];
        return;
    }
    
    if (self.freshPwdTF.text.length < 6 || self.freshPwdTF.text.length > 16) {
        [NYSTools showToast:NLocalizedStr(@"TipsPwdLength")];
        [NYSTools shakeAnimation:self.freshPwdTF.layer];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"phone": NAppManager.userInfo.phone,
        @"old_password": _pwdTF.text,
        @"new_password": _renewPwdTF.text,
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                          url:@"/index/Member/update_password"
                                      parameters:params
                                             remark:@"修改密码"
                                            success:^(id response) {
        @strongify(self)
        [NYSTools showIconToast:NLocalizedStr(@"Updated") isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            
            [NAppManager logout:^(BOOL success, id description) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self.navigationController popViewControllerAnimated:YES];
                        NPostNotification(NNotificationLoginStateChange, @NO)
                    } else {
                        [NYSTools showIconToast:NLocalizedStr(@"LogoutFail") isSuccess:NO offset:UIOffsetMake(0, 0)];
                    }
                });
            }];
        }];
    } failed:^(NSError * _Nullable error) {


    }];
}

@end
