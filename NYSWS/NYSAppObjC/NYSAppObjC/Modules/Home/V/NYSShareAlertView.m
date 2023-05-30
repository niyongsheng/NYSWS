//
//  NYSView.m
//  NYS
//
//  Created by niyongsheng.github.io on 2021/8/9.
//  Copyright © 2021 NYS. ALL rights reserved.
//

#import "NYSShareAlertView.h"

@interface NYSShareAlertView ()


@end

@implementation NYSShareAlertView

- (void)setupView {
    
    [self addRoundedCorners:self corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
    
}

- (IBAction)itemOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(sender.tag, @"");
    }
}

- (void)updateData:(id)data {

}

- (void)addRoundedCorners:(UIView *)view
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius {
    [self addRoundedCorners:view corners:corners radius:radius borderWidth:0 borderColor:UIColor.clearColor];
}

- (void)addRoundedCorners:(UIView *)view
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

@end
