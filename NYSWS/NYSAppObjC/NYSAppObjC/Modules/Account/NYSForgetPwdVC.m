//
//  NYSRecommendVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSForgetPwdVC.h"

@interface NYSForgetPwdVC ()

@end

@implementation NYSForgetPwdVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"忘记密码";
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    [self wr_setNavBarBackgroundAlpha:0];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addTarget:self action:@selector(backBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)backBtnOnclicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
