//
//  NYSRecommendVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSRecommendVC.h"
#import <SGQRCode/SGQRCode.h>

@interface NYSRecommendVC ()
@property (weak, nonatomic) IBOutlet UIImageView *inviteIV;

@end

@implementation NYSRecommendVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self wr_setNavBarBackgroundAlpha:0];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addTarget:self action:@selector(backBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    [shareBtn setBackgroundColor:UIColor.clearColor];
    [shareBtn addTarget:self action:@selector(shareBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    shareBtn.centerY = kScreenHeight * 0.2;
    
    NSString *str = @"http://www.baidu.com";
    UIImageView *qrIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.45, kScreenWidth * 0.45)];
    qrIV.image = [SGGenerateQRCode generateQRCodeWithData:str size:RealValue(200) logoImage:[UIImage imageNamed:@"logo"] ratio:NRadius];
    [self.inviteIV addSubview:qrIV];
    
    qrIV.centerX = self.view.centerX;
    qrIV.centerY = kScreenHeight * 0.65;
}

- (void)backBtnOnclicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnOnclicked:(UIButton *)sender {
    UIImage *contentImage = [self.inviteIV snapshotImage];
    [NYSTools systemShare:@[contentImage] controller:self completion:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
    }];
}

@end
