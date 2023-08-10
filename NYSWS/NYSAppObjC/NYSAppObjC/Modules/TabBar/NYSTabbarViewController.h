//
//  NYSTabbarViewController.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/28.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSTabbarViewController : NYSBaseTabBarController
/// 是否强制刷新缓存
@property (assign, nonatomic) BOOL isRecache;
- (instancetype)initWithIsRecache:(BOOL)isRecache;
@end

NS_ASSUME_NONNULL_END
