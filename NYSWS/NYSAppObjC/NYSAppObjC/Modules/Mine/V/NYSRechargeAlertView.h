//
//  NYSWalletHeader.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSRechargeAlertView : NYSBaseView
/// 是否充值
@property (nonatomic, assign) BOOL isRecharge;

@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) UIViewController *superVC;
@end

NS_ASSUME_NONNULL_END
