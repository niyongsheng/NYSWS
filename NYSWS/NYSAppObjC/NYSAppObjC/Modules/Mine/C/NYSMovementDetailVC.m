//
//  NYSAboutViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSMovementDetailVC.h"

@interface NYSMovementDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *wayL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *orderL;

@end

@implementation NYSMovementDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"BillDetail");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    NSMutableDictionary *params = @{
        @"order_id": self.model.order_id,
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Order/info"
                                      argument:params
                                             remark:@"订单详情"
                                            success:^(id response) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.moneyL.text = [NSString stringWithFormat:@"+%@", [response stringValueForKey:@"price" default:@""]];
            self.orderL.text = [response stringValueForKey:@"order_id" default:@""];
            self.timeL.text = [NYSTools transformTimestampToTime:[response[@"createtime"] integerValue] format:nil];
            self.statusL.text = [response[@"stauts"] isEqual:@"0"] ? NLocalizedStr(@"WaitPay") : NLocalizedStr(@"Payed");
            NSInteger payType = [response[@"pay_type"] intValue];
            if (payType == 0) {
                self.wayL.text = NLocalizedStr(@"WeChat");
            } else if (payType == 1) {
                self.wayL.text = NLocalizedStr(@"AliPay");
            } else if (payType == 2) {
                self.wayL.text = NLocalizedStr(@"Apple");
            } else if (payType == 3) {
                self.wayL.text = NLocalizedStr(@"BankCard");
            } else if (payType == 4) {
                self.wayL.text = NLocalizedStr(@"Foreign");
            }
        });

    } failed:^(NSError * _Nullable error) {


    }];
}

@end
