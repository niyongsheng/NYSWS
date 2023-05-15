//
//  NYSWalletHeader.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSRechargeAlertView : NYSBaseView
@property (nonatomic, strong) NSString *moneyStr;

@property (nonatomic, copy) NYSBlock block;
@end

NS_ASSUME_NONNULL_END
