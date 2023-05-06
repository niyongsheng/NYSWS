//
//  NYSAboutViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSAboutViewController.h"
#import <StoreKit/StoreKit.h>
#import <SVProgressHUD.h>

@interface NYSAboutViewController ()
<
SKStoreProductViewControllerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *versionL;

@end

@implementation NYSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    _versionL.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (IBAction)itemViewOnclicked1:(UIButton *)sender {
    NYSWebViewController *webVC = [NYSWebViewController new];
    webVC.urlStr = AppServiceAgreement;
    webVC.title = @"服务协议";
    webVC.autoTitle = NO;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)itemViewOnclicked2:(UIButton *)sender {
    NYSWebViewController *webVC = [NYSWebViewController new];
    webVC.urlStr = AppPrivacyAgreement;
    webVC.title = @"隐私协议";
    webVC.autoTitle = NO;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
