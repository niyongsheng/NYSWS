//
//  NYSTrackManager.h
//
//  📌高德猎鹰轨迹上报管理类
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

#import <Foundation/Foundation.h>

#define AmapKey @""
#define TrackManager    [NYSTrackManager sharedNYSTrackManager]

@interface NYSTrackManager : NSObject
+ (NYSTrackManager *)sharedNYSTrackManager;

/// 0.初始化轨迹上报
- (void)initTrackManager:(NSString *)serviceID terminalID:(NSString *)terminalID;

/// 1.开始轨迹上报
- (void)startTrackService:(NSString *)trackID;

/// 2.停止轨迹上报
- (void)stopTrackService;

#pragma mark - 始终定位权限检查
- (void)checkLocationPermission:(void(^)(bool permit))completed;

@end
