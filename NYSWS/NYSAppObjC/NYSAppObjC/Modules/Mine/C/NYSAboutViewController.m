//
//  NYSAboutViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSAboutViewController.h"
#import <StoreKit/StoreKit.h>
#import <SVProgressHUD.h>
#import "NYSProtocolDetailVC.h"

@interface NYSAboutViewController ()
<
SKStoreProductViewControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *versionL;

@end

@implementation NYSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"AboutOur");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    ViewRadius(_logoIV, 7)
    _versionL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"CourseVersion"), [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Index/about_us"
                                       parameters:nil
                                         remark:@"关于我们"
                                        success:^(id response) {
        @strongify(self)


    } failed:^(NSError * _Nullable error) {

    }];
}

- (IBAction)itemViewOnclicked1:(UIButton *)sender {
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/get_user_agreement"
                                       parameters:nil
                                         remark:@"服务协议"
                                        success:^(id response) {
        @strongify(self)
//        NYSWebViewController *webVC = [NYSWebViewController new];
//        webVC.urlStr = [response stringValueForKey:@"value" default:AppServiceAgreement];
//        webVC.title = NLocalizedStr(@"UserProtocol");
//        webVC.autoTitle = NO;
//        [self.navigationController pushViewController:webVC animated:YES];
        
        NYSProtocolDetailVC *detailVC = [NYSProtocolDetailVC new];
        detailVC.contentStr = [response stringValueForKey:@"value" default:AppServiceAgreement];
        detailVC.title = NLocalizedStr(@"UserProtocol");
        [self.navigationController pushViewController:detailVC animated:YES];

    } failed:^(NSError * _Nullable error) {

    }];
}

- (IBAction)itemViewOnclicked2:(UIButton *)sender {
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/get_privacy_agreement"
                                       parameters:nil
                                         remark:@"隐私协议"
                                        success:^(id response) {
        @strongify(self)
//        NYSWebViewController *webVC = [NYSWebViewController new];
//        webVC.urlStr = [response stringValueForKey:@"value" default:AppPrivacyAgreement];
//        webVC.title = NLocalizedStr(@"PrivacyProtocol");
//        webVC.autoTitle = NO;
//        [self.navigationController pushViewController:webVC animated:YES];
        
        NYSProtocolDetailVC *detailVC = [NYSProtocolDetailVC new];
        detailVC.contentStr = [response stringValueForKey:@"value" default:AppServiceAgreement];
        detailVC.title = NLocalizedStr(@"PrivacyProtocol");
        [self.navigationController pushViewController:detailVC animated:YES];

    } failed:^(NSError * _Nullable error) {

    }];
}

@end
