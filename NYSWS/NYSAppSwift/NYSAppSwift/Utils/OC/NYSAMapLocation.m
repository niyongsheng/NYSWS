//
//  NYSAMapLocation.h
//
//  📌高德定位管理类
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

#import "NYSAMapLocation.h"

@interface NYSAMapLocation () <AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation NYSAMapLocation

- (instancetype)init {
    self = [super init];;
    if (self) {
        [AMapServices sharedServices].apiKey = AmapKey;
        [self configLocationManager];
        [self initCompleteBlock];
    }
    return self;
}

#pragma mark - Action Handle
- (void)configLocationManager {
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];

    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    // 设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    // 设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    // 设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    // 设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    // 设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction {
    // 停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)reGeocodeAction {
    // 进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction {
    // 进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock {
    // 定位
    return [self.locationManager requestLocationWithReGeocode:withReGeocode completionBlock:completionBlock];
}

#pragma mark - Initialization
- (void)initCompleteBlock {
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error != nil && error.code == AMapLocationErrorLocateFailed) {
            NSLog(@"[NYSAMapLocation]定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            
        } else if (error != nil && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost)) {
            
            // 逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"[NYSAMapLocation]逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            
        } else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation) {
            
            // 存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"[NYSAMapLocation]存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        if (error) {
            [NYSTools showIconToast:[NSString stringWithFormat:@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription] isSuccess:false offset:UIOffsetMake(0, 0)];
            if (weakSelf.completion) {
                weakSelf.completion(nil, nil, nil, error);
            }
            return;
        }
        
        if (regeocode) {
            NSLog(@"%@", [NSString stringWithFormat:@"[NYSAMapLocation]%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]);
        } else {
            NSLog(@"%@", [NSString stringWithFormat:@"[NYSAMapLocation]lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
        }
        
        if (weakSelf.completion) {
            NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
            weakSelf.completion(regeocode.formattedAddress, latitude, longitude, error);
        }
    };
}

#pragma mark - AMapLocationManager Delegate
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

@end
