//
//  NYSIconLeftButton.h
//  ICMSClient
//
//  Created by niyongsheng.github.io on 2021/11/25.
//  Copyright © 2021 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSIconLeftButton : UIButton

/*
 *提示：先设置titleRect和imageRect，再设置frame，否则iOS9.0会有布局问题
 */
@property (nonatomic,assign) CGRect titleRect;
@property (nonatomic,assign) CGRect imageRect;

@end

NS_ASSUME_NONNULL_END
