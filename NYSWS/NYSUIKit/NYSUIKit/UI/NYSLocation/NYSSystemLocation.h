//
//  NYSSystemLocation.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NYSLocationCompletion)(NSString * _Nonnull address, NSString * _Nonnull latitude, NSString * _Nonnull longitude, NSError * _Nullable error);

@interface NYSSystemLocation : NSObject

#pragma mark - 系统定位
- (void)requestSystemLocation;

/// 定位结果
@property (nonatomic, copy) NYSLocationCompletion _Nullable completion;

@end
