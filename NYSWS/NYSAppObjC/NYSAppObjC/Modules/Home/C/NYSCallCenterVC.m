//
//  NYSCallCenterVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSCallCenterVC.h"

@interface NYSCallCenterVC ()
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UILabel *telL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;

@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation NYSCallCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客服";
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Index/contact_us"
                                       argument:nil
                                         remark:@"联系我们"
                                        success:^(id response) {
        @strongify(self)
        self.dataDict = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.addressL.text = [NSString stringWithFormat:@"%@", [response stringValueForKey:@"address" default:@""]];
            self.emailL.text = [NSString stringWithFormat:@"客服邮箱：%@", [response stringValueForKey:@"email" default:@""]];
            self.telL.text = [NSString stringWithFormat:@"座机电话：%@", [response stringValueForKey:@"tel" default:@""]];
            self.phoneL.text = [NSString stringWithFormat:@"手机电话：%@", [response stringValueForKey:@"phone" default:@""]];
        });

    } failed:^(NSError * _Nullable error) {

    }];
    
    // 打电话
    self.telL.userInteractionEnabled = YES;
    [self.telL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.dataDict[@"tel"]]] options:@{} completionHandler:nil];
    }]];
    
    // 打手机
    self.phoneL.userInteractionEnabled = YES;
    [self.phoneL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.dataDict[@"phone"]]] options:@{} completionHandler:nil];
    }]];
    
    // 发邮件
    self.emailL.userInteractionEnabled = YES;
    [self.emailL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[@"mailto:" stringByAppendingString:self.dataDict[@"email"]]] options:@{} completionHandler:nil];
    }]];
}

@end
