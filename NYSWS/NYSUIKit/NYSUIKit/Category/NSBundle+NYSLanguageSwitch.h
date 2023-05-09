//
//  NSBundle+NYSLanguageSwitch.h
//  NYSUIKit
//
//  Created by niyongsheng on 2023/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (NYSLanguageSwitch)
+ (BOOL)isChineseLanguage;

+ (NSString *)currentLanguage;
@end

NS_ASSUME_NONNULL_END
