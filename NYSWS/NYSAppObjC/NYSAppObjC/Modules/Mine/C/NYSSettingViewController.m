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
#import "NYSResetPwdViewController.h"
#import <SVProgressHUD.h>

@interface NYSSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation NYSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"MySetting");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.logoutBtn.hidden = !NAppManager.isLogined;
}

- (IBAction)itemViewOnclicked0:(UIButton *)sender {
    [self.navigationController pushViewController:NYSUpdateInfoVC.new animated:YES];
}

- (IBAction)itemViewOnclicked1:(UIButton *)sender {
    [self.navigationController pushViewController:NYSResetPwdViewController.new animated:YES];
}

- (IBAction)itemViewOnclicked2:(UIButton *)sender {
    [self.navigationController pushViewController:NYSSecurityProtectionVC.new animated:YES];
}

- (IBAction)logoutBtnOnclicked0:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NLocalizedStr(@"Tips") message:NLocalizedStr(@"TipsSubtitle") preferredStyle:UIAlertControllerStyleActionSheet];
    if (CurrentSystemVersion < 13.0) {
        [UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]].lee_theme.LeeConfigBackgroundColor(@"normal_corner_style_bg_color");
        alertController.view.layer.cornerRadius = 15.0f;
        alertController.view.layer.masksToBounds = YES;
    }
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:NLocalizedStr(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NLocalizedStr(@"Commit") style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        
        [NAppManager logout:^(BOOL success, id description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [NYSTools showIconToast:NLocalizedStr(@"LogoutSuccess") isSuccess:YES offset:UIOffsetMake(0, 0)];
                    [SVProgressHUD dismissWithDelay:1.0f completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        NPostNotification(NNotificationLoginStateChange, @NO)
//                        NYSBaseNavigationController *loginVC = [[NYSBaseNavigationController alloc] initWithRootViewController:[NYSLoginVC new]];
//                        [NRootViewController presentViewController:loginVC animated:YES completion:nil];
                    }];
                } else {
                    [NYSTools showIconToast:NLocalizedStr(@"LogoutFail") isSuccess:NO offset:UIOffsetMake(0, 0)];
                    [SVProgressHUD dismissWithDelay:0.4f];
                }
            });
        }];
    }];
    [alertController addAction:laterAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
