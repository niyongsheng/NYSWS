//
//  NYSKitManager.m
//  NYSKit
//
//  Created by niyongsheng on 2023/4/23.
//

#import "NYSKitManager.h"

@implementation NYSKitManager

+ (NYSKitManager *)sharedNYSKitManager {
    static NYSKitManager *sharedNYSKitManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNYSKitManager = [[self alloc] init];
    });
    return sharedNYSKitManager;
}
@end
