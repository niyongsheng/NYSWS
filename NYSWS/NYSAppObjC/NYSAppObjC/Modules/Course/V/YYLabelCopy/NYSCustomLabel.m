//
//  NYSCustomLabel.m
//
//  Created by niyongsheng on 2023/5/23.
//

#import "NYSCustomLabel.h"

@implementation NYSCustomLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 让label能够响应用户的交互
        self.userInteractionEnabled = YES;
        
        // 给label添加手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        // 设置长按最少需要2s
        longPressGesture.minimumPressDuration = 0.5;
        // 添加长按响应事件
        [longPressGesture addTarget:self action:@selector(longPressAction:)];
        // 添加手势
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

/// 长按手势事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGes {
    // 让label成为第一响应者
    [self becomeFirstResponder];
    // 长按label时展示出复制选项(还可以定义剪贴,粘贴)
    // 创建UIMenuController
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:NLocalizedStr(@"Copy") action:@selector(copyAction)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:copyItem]];
    // 设置frame和添加到的视图
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    // 设置弹窗可见
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

/// copy按钮点击事件
- (void)copyAction {
    // 将label上的字符串保存到 UIPasteboard 上
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}

#pragma mark - UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(copyAction);
}


#pragma mark - 富文本转换
+ (NSMutableAttributedString *)getAttributedString:(NSString *)string {
    if (!string || string.length == 0) {
        return nil;
    }
    
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
    if (aString == nil) {
        return CGRectZero;
    }
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:aString];
    CGRect frame = CGRectMake(0, 0, width, layout.textBoundingSize.height);
    return frame;
}

@end
