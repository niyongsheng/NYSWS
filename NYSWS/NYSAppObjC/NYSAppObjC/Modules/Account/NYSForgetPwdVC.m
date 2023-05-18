//
//  NYSRecommendVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSForgetPwdVC.h"

@interface NYSForgetPwdVC ()
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *wechat;

@end

@implementation NYSForgetPwdVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NLocalizedStr(@"ForgetPwd");
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    [self wr_setNavBarBackgroundAlpha:0];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addTarget:self action:@selector(backBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/get_service"
                                       argument:nil
                                         remark:@"获取客服"
                                        success:^(id response) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qq = [[response firstObject] stringValueForKey:@"value" default:@""];
            self.wechat = [[response lastObject] stringValueForKey:@"value" default:@""];
            [self.qqBtn setTitle:[NSString stringWithFormat:@"QQ：%@", self.qq] forState:UIControlStateNormal];
            [self.wechatBtn setTitle:[NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"Wechat"), self.wechat] forState:UIControlStateNormal];
        });

    } failed:^(NSError * _Nullable error) {

    }];
}

- (void)backBtnOnclicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)qqBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.qq;
    [NYSTools showToast:NLocalizedStr(@"Copied")];
}

- (IBAction)wechatBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.wechat;
    [NYSTools showToast:NLocalizedStr(@"Copied")];
}

@end
