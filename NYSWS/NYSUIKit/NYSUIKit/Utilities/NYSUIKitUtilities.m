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
        CGFloat h = statusBarManager.statusBarFrame.size.height;
        return h;
    } else {
        CGFloat h = [UIApplication sharedApplication].statusBarFrame.size.height;
        return h;
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
        CGFloat h = window.safeAreaInsets.bottom;
        return h;
        
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        CGFloat h = window.safeAreaInsets.bottom;
        return h;
    }
    
    if (isIphonex) {
        return 34.0f;
    } else {
        return 0;
    }
}

/// 读取包中图片资源
/// - Parameter name: 名称
/// mark: 如果bundle获取到的一直是app的资源名，需要把Framework修改成动态库 MACH_O_TYPE = dynamic
+ (nullable UIImage *)imageNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (nullable UIImage *)imageBundleNamed:(NSString *)name {
    NSBundle*bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"NYSUIKit.bundle/image"  inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
