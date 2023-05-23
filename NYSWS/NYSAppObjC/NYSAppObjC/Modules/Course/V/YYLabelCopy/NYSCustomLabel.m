//
//  NYSCustomLabel.m
//
//  Created by niyongsheng on 2023/5/23.
//

#import "NYSCustomLabel.h"

@implementation NYSCustomLabel

#pragma mark - 富文本转换
+ (NSMutableAttributedString *)getAttributedString:(NSString *)string {
    NSMutableAttributedString *oneString = [[NSMutableAttributedString alloc]initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    oneString.font = [UIFont systemFontOfSize:13];
    oneString.color = [UIColor darkGrayColor];
    oneString.lineSpacing = 5;
    
    [oneString enumerateAttributesInRange:oneString.rangeOfAll
                                  options:0
                               usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSURL *link = [attrs objectForKey:NSLinkAttributeName];
        if (link) {
            // 链接变颜色
            [oneString setTextHighlightRange:range
                                       color:[UIColor blueColor]
                             backgroundColor:[UIColor whiteColor]
                                   tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.absoluteString] options:@{} completionHandler:nil];
            }];
        }
    }];
    
    return oneString;
}

#pragma mark - 富文本尺寸计算
+ (CGRect)getAttributedStringFrame:(NSMutableAttributedString *)aString width:(CGFloat)width {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:aString];
    CGRect frame = CGRectMake(0, 0, width, layout.textBoundingSize.height);
    return frame;
}

@end
