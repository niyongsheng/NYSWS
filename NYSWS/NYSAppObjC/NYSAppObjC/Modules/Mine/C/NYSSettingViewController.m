//
//  NYSSettingViewController.m
//  LKXiaoLuZSB
//
//  Created by niyongsheng on 2022/11/10.
//  Copyright © 2022 niyongsheng. All rights reserved.
//

#import "NYSSettingViewController.h"
#import "NYSUpdateInfoVC.h"
#import "NYSSecurityProtectionVC.h"
#import <SVProgressHUD.h>

@interface NYSSettingViewController ()

@end

@implementation NYSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
}

- (IBAction)itemViewOnclicked0:(UIButton *)sender {
    [self.navigationController pushViewController:NYSUpdateInfoVC.new animated:YES];
}

- (IBAction)itemViewOnclicked1:(UIButton *)sender {
    
}

- (IBAction)itemViewOnclicked2:(UIButton *)sender {
    [self.navigationController pushViewController:NYSSecurityProtectionVC.new animated:YES];
}

- (IBAction)logoutBtnOnclicked0:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录吗 ?" preferredStyle:UIAlertControllerStyleActionSheet];
    if (CurrentSystemVersion < 13.0) {
        [UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]].lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        alertController.view.layer.cornerRadius = 15.0f;
        alertController.view.layer.masksToBounds = YES;
    }
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        
//        [NUserManager logout:^(BOOL success, id description) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success) {
//                    [NYSTools showIconToast:@"登出成功" isSuccess:YES offset:UIOffsetMake(0, 0)];
//                    [SVProgressHUD dismissWithDelay:1.0f completion:^{
//                        [self.navigationController popViewControllerAnimated:YES];
////                        NPostNotification(NNotificationLoginStateChange, @NO)
//                    }];
//                } else {
//                    [NYSTools showIconToast:@"登出失败" isSuccess:NO offset:UIOffsetMake(0, 0)];
//                    [SVProgressHUD dismissWithDelay:0.4f];
//                }
//            });
//        }];
    }];
    [alertController addAction:laterAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
