//
//  NYSCustomLabel.h
//
//  Created by niyongsheng on 2023/5/23.
//

#import "YYLabel.h"
#import "YYLabel+Copy.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYSCustomLabel : UILabel

+ (NSMutableAttributedString *)getAttributedString:(NSString *)string;

+ (CGRect)getAttributedStringFrame:(NSMutableAttributedString *)aString width:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
