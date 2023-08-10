//
//  NYSTools.m
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/6/3.
//  Copyright © 2019 NYS. ALL rights reserved.
//

#import "NYSTools.h"
#import "PublicHeader.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation NYSTools

#pragma mark - 核心动画相关
/**
 弹性缩放动画
 
 @param layer 作用图层
 */
+ (void)zoomToShow:(CALayer *)layer {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.5)]];
    
    animation.values = values;
    [layer addAnimation:animation forKey:nil];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
}

/**
 左右晃动动画
 
 @param layer 作用图层
 */
+ (void)swayToShow:(CALayer *)layer {
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.37;
    keyAnimaion.repeatCount = 0;
    [layer addAnimation:keyAnimaion forKey:nil];
}

/**
 左右抖动动画（错误提醒）
 
 @param layer 左右图层
 */
+ (void)shakeAnimation:(CALayer *)layer {
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 3.0f, position.y);
    CGPoint x = CGPointMake(position.x + 3.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

/// 删除动画抖动效果
/// @param layer 作用图层
+ (void)deleteAnimation:(CALayer *)layer {

    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1f;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.fromValue= [NSValue valueWithCATransform3D:CATransform3DRotate(layer.transform,-0.08,0.0,0.0,0.08)];
    animation.toValue= [NSValue valueWithCATransform3D:CATransform3DRotate(layer.transform,0.08,0.0,0.0,0.08)];
    [layer addAnimation:animation forKey:@"wiggle"];
}

/**
 按钮左右抖动动画（错误提醒）
 
 @param button 作用按钮
 */
+ (void)shakToShow:(UIButton *)button {
    CGFloat t = 4.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    button.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        button.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
}

/**
 滚动动画
 
 @param duration 滚动显示
 @param layer 作用图层
 */
+ (void)animateTextChange:(CFTimeInterval)duration withLayer:(CALayer *)layer {
    CATransition *trans = [[CATransition alloc] init];
    trans.type = kCATransitionMoveIn;
    trans.subtype = kCATransitionFromTop;
    trans.duration = duration;
    trans.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [layer addAnimation:trans forKey:kCATransitionPush];
}


#pragma mark - 时间相关
/// 获取当前时间戳（单位：秒）
+ (NSString *)getNowTimeTimestamp {

    NSDate *datenow = [NSDate date];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;
}

/// 将时间戳转换成格式化的时间字符串
/// @param timestamp 时间戳
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
+ (NSString *)transformTimestampToTime:(NSTimeInterval)timestamp format:(NSString *)format {
    if (!format) format = @"YYYY-MM-dd HH:mm:ss";
    
    NSTimeInterval interval = timestamp / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

/// 将某个时间转化成 时间戳
/// @param formatTime 时间z字符串
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
+ (NSTimeInterval)transformTimeToTimestamp:(NSString *)formatTime format:(NSString *)format {
    if (!format) format = @"YYYY-MM-dd HH:mm:ss";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];
    
    // 时间转时间戳的方法:
    NSTimeInterval timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}

/// 将某个时间戳转化成 时间
/// @param timestamp 时间戳
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

/**
 时间戳转换成XX分钟之前
 @param timestamp 时间戳
 */
+ (NSString *)timeBeforeInfoWithTimestamp:(NSInteger)timestamp {
    // 获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timestamp; // 时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前", year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前", month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前", day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前", hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前", minute];
    }else if(second > 0){
        return [NSString stringWithFormat:@"%d秒钟以前", second];
    }
    return [NSString stringWithFormat:@"刚刚"];
}

/// 计算年纪
/// @param birthdayStr >=4位生日字符串（1991-01-01）
+ (NSInteger)getAgeWithBirthdayString:(NSString *)birthdayStr {
    if (!birthdayStr) return 0;

    NSInteger birthdayYear = [[birthdayStr substringToIndex:4] integerValue];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSInteger currentYear = [[format stringFromDate:[NSDate date]] integerValue];
    
    return currentYear - birthdayYear;
}


#pragma mark - 圆角边框相关
/// 添加圆角阴影效果
/// @param theView 目标view
/// @param theColor 阴影颜色
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 10.0;

    theView.layer.cornerRadius = 10.0;
    
    theView.clipsToBounds=NO;
}


////图片圆角效果（贝塞尔曲线方式）
/// @param img 目标图片
/// @param cornerRadius 圆角尺度
+ (UIImage *)rh_bezierPathClip:(UIImage *)img
                  cornerRadius:(CGFloat)cornerRadius {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    CGRect rect = (CGRect){CGPointZero, CGSizeMake(w, h)};

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [img drawInRect:rect];
    UIImage *cornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cornerImage;
}

/// 添加部分圆角
/// @param view 作用域
/// @param corners UIRectCorner
/// @param radius 圆角半径
+ (void)addRoundedCorners:(UIView *)view
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius {
    [self addRoundedCorners:view corners:corners radius:radius borderWidth:0 borderColor:UIColor.clearColor];
}

/// 添加部分圆角和边框
/// @param view 作用域
/// @param corners UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
/// @param radius 圆角半径
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
+ (void)addRoundedCorners:(UIView *)view
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.frame;
    maskLayer.path = path.CGPath;
    maskLayer.lineWidth = borderWidth;
    maskLayer.strokeColor = borderColor.CGColor;
    view.layer.mask = maskLayer;
}


#pragma mark - 字符串处理相关
///  判断NSString值是否为空或null并转换为空字符串
/// @param string str
+ (NSString *)nullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
    }
}

/// YES null    NO !null
/// @param string   str
+ (BOOL)stringIsNull:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}

/// 拼音转换
/// @param str content
+ (NSString *)transformToPinyin:(NSString *)str {
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

/// 姓名加*
/// @param string 姓名
+ (NSString *)nameStringAsteriskHandle:(NSString *)string {
    if ([self stringIsNull:string]) {
        return @"*";
    }
    
    if (string.length <= 2) {
        NSString *preStr = [string substringToIndex:1];
        return [preStr stringByAppendingString:@"*"];
    }
    
    if (string.length <= 3) {
        NSString *preStr = [string substringToIndex:1];
        NSString *sufStr = [string substringFromIndex:2];
        return [NSString stringWithFormat:@"%@*%@", preStr, sufStr];
    }
    
    NSString *preStr = [string substringToIndex:2];
    return [preStr stringByAppendingString:@"**"];
}

/// 号码加*
/// @param string 号码
+ (NSString *)phoneStringAsteriskHandle:(NSString *)string {
    if ([self stringIsNull:string]) {
        return @"*";
    }
    
    if (string.length < 7) {
        NSString *preStr = [string substringToIndex:4];
        return [preStr stringByAppendingString:@"***"];
    }
    
    if (6 < string.length && string.length <= 11) {
        NSString *preStr = [string substringToIndex:3];
        NSString *sufStr = [string substringFromIndex:7];
        return [NSString stringWithFormat:@"%@****%@", preStr, sufStr];
        
    } else {
//        NSString *mStr = [string substringWithRange:NSMakeRange(2, 4)];
        NSString *preStr = [string substringToIndex:4];
        return [preStr stringByAppendingString:@"****"];
    }
}

#pragma mark - 提示相关
/// Toast 头部
/// @param msg 内容
+ (void)showTopToast:(NSString *)msg {
    [self showToast:msg imageNamed:@"_NULL" offset:UIOffsetMake(0, -[[UIScreen mainScreen] bounds].size.width * 0.3)];
}

/// Toast 底部
/// @param msg 内容
+ (void)showBottomToast:(NSString *)msg {
    [self showToast:msg imageNamed:@"" offset:UIOffsetMake(0, [[UIScreen mainScreen] bounds].size.height * 0.4)];
}

+ (void)showToast:(NSString *)msg {
    [self showToast:msg imageNamed:@"" offset:UIOffsetMake(0, 0)];
}

+ (void)showToast:(NSString *)msg imageNamed:(NSString *)name offset:(UIOffset)offset {
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showImage:[UIImage imageNamed:name] status:msg];
    [SVProgressHUD dismissWithDelay:1.25f completion:nil];
}

+ (void)showIconToast:(NSString *)msg isSuccess:(BOOL)isSuccess offset:(UIOffset)offset {
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if (isSuccess) {
        [SVProgressHUD showSuccessWithStatus:msg];
    } else {
        [SVProgressHUD showInfoWithStatus:msg];
    }
}

+ (void)dismissWithCompletion:(NYSToolsDismissCompletion)completion {
    [SVProgressHUD dismissWithDelay:1.1f completion:completion];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(NYSToolsDismissCompletion)completion {
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

#pragma mark - 其他
/**
 系统分享
 @param items 需要分享的类目，可以包括文字，图片，网址
 @param controller 视图控制器
 @param completion 回调
 */
+ (void)systemShare:(NSArray *)items controller:(UIViewController *)controller completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityVC.modalInPresentation = YES;
    activityVC.completionWithItemsHandler = completion;
    [controller presentViewController:activityVC animated:YES completion:nil];
}

@end
