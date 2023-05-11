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
    
    self.navigationItem.title = @"修改问题";

    ViewRadius(_commitBtn, 22.5f)
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    if (![_pwdTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入旧密码"];
        return;
    }
    
    if (![_freshPwdTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入新密码"];
        return;
    }
    
    if (![_renewPwdTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入重复新密码"];
        return;
    }
    
    if (![_freshPwdTF.text isEqualToString:_renewPwdTF.text]) {
        [NYSTools showToast:@"两次输入的新密码不一致"];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"phone": NAppManager.userInfo.phone,
        @"old_password": _pwdTF.text,
        @"password": _renewPwdTF.text,
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Member/update_pass"
                                      argument:params
                                             remark:@"修改密码"
                                            success:^(id response) {
        @strongify(self)
        [NYSTools showIconToast:@"已更新" isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(NSError * _Nullable error) {


    }];
}

@end
