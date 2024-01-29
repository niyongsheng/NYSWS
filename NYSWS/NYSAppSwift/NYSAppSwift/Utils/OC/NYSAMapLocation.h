//
//  NYSAMapLocation.h
//
//  📌高德定位管理类
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
#define AmapKey @""

NS_ASSUME_NONNULL_BEGIN

typedef void (^NYSAMapLocationCompletion)(NSString *address, NSString *latitude,NSString *longitude, NSError *error);

@interface NYSAMapLocation : NSObject

/// 单次定位
- (void)locAction;

/// 单次逆地理定位
- (void)reGeocodeAction;

/// 停止定位
/// 调用此方法会cancel掉所有的单次定位请求，可以用来取消单次定位
- (void)cleanUpAction;

/// 定位结果
@property (nonatomic, copy) NYSAMapLocationCompletion completion;

@end

NS_ASSUME_NONNULL_END
