//
//  NYSLoginVC.h
//  LKBusinessCollege
//
//  Created by niyongsheng.github.io on 2022/7/29.
//  Copyright © 2022 NYS. ALL rights reserved.
//

#import <NYSUIKit/NYSUIKit.h>

typedef NS_ENUM(NSInteger, NYSLoginType)
{
    NYSLoginTypeSms,
    NYSLoginTypePwd
};

NS_ASSUME_NONNULL_BEGIN

@interface NYSLoginVC : NYSBaseViewController

@property (nonatomic, assign) NYSLoginType *loginType;

@end

NS_ASSUME_NONNULL_END
