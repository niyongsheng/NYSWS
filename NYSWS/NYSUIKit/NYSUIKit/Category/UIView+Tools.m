//
//  UIView+Tools.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "UIView+Tools.h"
#define kLinePix ( 1 / [UIScreen mainScreen].scale)

@implementation UIView (Tools)
#pragma mark - StoryBoard tool
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth * kLinePix;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

+ (UIView*)loadingAnimation {
    UIWindow *keywindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keywindow = window;
            break;
        }
    }
    CGFloat width = keywindow.frame.size.width;
    CGFloat height = keywindow.frame.size.height;
    UIView *animationBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    animationBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    UIImageView *animation = [[UIImageView alloc] init];
    animation.frame = CGRectMake(0, 0, 80, 80);
    animation.center = animationBg.center;
    [animationBg addSubview:animation];
//    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"loading_gif_plane" withExtension:@"gif"];
//    [animation setImageURL:gifImageUrl];
    animationBg.tag = 1000001;
    [keywindow addSubview:animationBg];
    return animationBg;
}

+ (void)removeLoadingAnimation {
    UIWindow *keywindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keywindow = window;
            break;
        }
    }
    UIView *animationBg = [keywindow viewWithTag:1000001];
    [animationBg removeFromSuperview];
}

@end
