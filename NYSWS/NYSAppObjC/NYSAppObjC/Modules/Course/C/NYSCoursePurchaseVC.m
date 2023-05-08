//
//  NYSCourseExchangeVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCoursePurchaseVC.h"

@interface NYSCoursePurchaseVC ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *coinL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *infoL;


@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSCoursePurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    [self wr_setNavBarBarTintColor:NAppThemeColor];
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    
    self.view.backgroundColor = NAppThemeColor;
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    ViewRadius(_contentV, 30);
    ViewRadius(_commitBtn, 22.5);

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    
}

@end

