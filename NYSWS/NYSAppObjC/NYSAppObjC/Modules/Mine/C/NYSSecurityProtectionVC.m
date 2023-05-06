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

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation NYSSecurityProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密保问题";

    ViewRadius(_commitBtn, 22.5f)
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    if (![_nameTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入姓名"];
        return;
    }
    
//    NSMutableDictionary *params = @{
//        @"token": NUserToken
//      }.mutableCopy;
//    [params setValue:_areaTF.text forKey:@"province"];
//    [params setValue:_schoolTF.text forKey:@"school"];
//    [params setValue:_majorTF.text forKey:@"major"];
//
//    WS(weakSelf)
//    [NYSRequestManager jsonNetworkRequestWithMethod:@"POST"
//                                          url:PUT_UpdateUserInfo
//                                      argument:params
//                                             remark:@"完善信息"
//                                            success:^(id response) {
//        // 刷新用户信息
//        [NUserManager loadUserInfoCompletion:nil];
//
//        [NYSTools showIconToast:@"信息已完善" isSuccess:YES offset:UIOffsetMake(0, 0)];
//        [SVProgressHUD dismissWithDelay:1.0f completion:^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }];
//
//    } failed:^(NSError * _Nullable error) {
//
//
//    }];
    
}


@end
