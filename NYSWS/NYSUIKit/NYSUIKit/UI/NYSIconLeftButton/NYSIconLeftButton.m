//
//  NYSIconLeftButton.m
//  ICMSClient
//
//  Created by niyongsheng.github.io on 2021/11/25.
//  Copyright © 2021 NYS. ALL rights reserved.
//

#import "NYSIconLeftButton.h"

@implementation NYSIconLeftButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}

@end
