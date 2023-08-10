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

@property (weak, nonatomic) IBOutlet UILabel *qqL;
@property (weak, nonatomic) IBOutlet UILabel *wcL;
@property (weak, nonatomic) IBOutlet UILabel *waL;

@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *wechat;
@property (strong, nonatomic) NSString *whatsapp;

@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation NYSCallCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"Service");
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
            self.emailL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"CustomerServiceEmail"), [response stringValueForKey:@"email" default:@""]];
            self.telL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"TelPhone"), [response stringValueForKey:@"tel" default:@""]];
            self.phoneL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"MobilePhone"), [response stringValueForKey:@"phone" default:@""]];
        });

    } failed:^(NSError * _Nullable error) {

    }];
    
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/get_service"
                                       argument:nil
                                         remark:@"获取客服"
                                        success:^(id response) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSDictionary *obj in response) {
                NSString *config = [obj stringValueForKey:@"config" default:@""];
                NSString *value = [obj stringValueForKey:@"value" default:@""];
                if ([config isEqualToString:@"service_wechat"]) {
                    self.wechat = value;
                    self.wcL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"Wechat"), self.wechat];
                    
                } else if ([config isEqualToString:@"service_qq"]) {
                    self.qq = value;
                    self.qqL.text =  [NSString stringWithFormat:@"QQ：%@", self.qq];
                    
                } else if ([config isEqualToString:@"WhatsApp"]) {
                    self.whatsapp = value;
                    self.waL.text = [NSString stringWithFormat:@"WhatsApp：%@", self.whatsapp];
                }
            }
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
    
    self.qqL.userInteractionEnabled = YES;
    [self.qqL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqBtnOnclicked:)]];
    
    self.wcL.userInteractionEnabled = YES;
    [self.wcL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatBtnOnclicked:)]];
    
    self.waL.userInteractionEnabled = YES;
    [self.waL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whatsappBtnOnclicked:)]];
}

- (void)qqBtnOnclicked:(UILabel *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.qq;
    [NYSTools showToast:NLocalizedStr(@"Copied")];
}

- (void)wechatBtnOnclicked:(UILabel *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.wechat;
    [NYSTools showToast:NLocalizedStr(@"Copied")];
}

- (void)whatsappBtnOnclicked:(UILabel *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.whatsapp;
    [NYSTools showToast:NLocalizedStr(@"Copied")];
}

@end
