//
//  NYSUIKitUtilities.m
//  NYSUIKit
//
//  Created by niyongsheng on 2023/4/28.
//

#import "NYSUIKitUtilities.h"

// 判断iphoneX
#define isIphonex ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

@implementation NYSUIKitUtilities

+ (CGFloat)nys_navigationHeight {
    return 44.f;
}

+ (CGFloat)nys_statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGFloat)nys_navigationFullHeight {
    return [self nys_statusBarHeight] + 44;
}
 
+ (CGFloat)nys_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
        
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    
    if (isIphonex) {
        return 34.0f;
    } else {
        return 0;
    }
}

/// 读取包中图片资源
/// - Parameter name: 名称
+ (nullable UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

@end
