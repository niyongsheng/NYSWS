//
//  NYSSystemLocation.m
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSSystemLocation.h"
#import "PublicHeader.h"
#import <CoreLocation/CoreLocation.h>

@interface NYSSystemLocation ()
<
CLLocationManagerDelegate
>

@property (nonatomic, strong) CLLocationManager *sysLocationManager;

@end

@implementation NYSSystemLocation

- (instancetype)init {
    if (self = [super init]) {
        self.sysLocationManager = [[CLLocationManager alloc] init];
        [self.sysLocationManager setDelegate:self];
        [self.sysLocationManager requestWhenInUseAuthorization];
        [self.sysLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
    return self;
}

#pragma mark - 系统定位
- (void)requestSystemLocation {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        if ([CLLocationManager locationServicesEnabled]) {
            [self.sysLocationManager startUpdatingLocation];
        } else {
            [NYSTools showIconToast:@"Location services disable" isSuccess:false offset:UIOffsetMake(0, 0)];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    NSLog(@"NYSLocation: lat%f long%f", coordinate.latitude, coordinate.longitude);

    // 系统逆地理编码
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];

    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@", placemark.administrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare];
            if (weakSelf.completion) {
                weakSelf.completion(address, [NSString stringWithFormat:@"%f", coordinate.latitude], [NSString stringWithFormat:@"%f", coordinate.latitude], error);
            }
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        } else if (error) {
            NSLog(@"NYSLocation error: %@ ", error);
        }
    }];

    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
    NSLog(@"DidFailWithError: %@", error);
    if (_completion) {
        self.completion(@"", @"", @"", error);
    }
}

- (void)dealloc {
    [self.sysLocationManager stopUpdatingLocation];
    self.sysLocationManager.delegate = nil;
    self.sysLocationManager = nil;
}

@end
