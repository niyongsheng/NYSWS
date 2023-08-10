//
//  EMAppStorePay.h
//  MobileFixCar
//
//  Created by Wcting on 2018/4/11.
//  Copyright © 2018年 XXX有限公司. All rights reserved.
//

/*
 wct20180917 内购支付类，短视频e豆购买用到。
 */

#import <Foundation/Foundation.h>

@class EMAppStorePay;

@protocol EMAppStorePayDelegate <NSObject>;

@optional

/**
 wct20180418 内购支付成功回调

 @param appStorePay 当前类
 @param dicValue 返回值
 @param error 错误信息
 */
- (void)EMAppStorePay:(EMAppStorePay *)appStorePay responseAppStorePaySuccess:(NSDictionary *)dicValue error:(NSError*)error;


/**
 wct20180423 内购支付结果回调提示
 
 @param appStorePay 当前类
 @param dicValue 返回值
 @param error 错误信息
 */
- (void)EMAppStorePay:(EMAppStorePay *)appStorePay responseAppStorePayStatusshow:(NSDictionary *)dicValue error:(NSError*)error;

@end

@interface EMAppStorePay : NSObject

@property (nonatomic, weak)id<EMAppStorePayDelegate> delegate;/**<wct20180418 delegate*/


/**
  wct20180411 点击购买

 @param goodsID 商品id
 */
-(void)starBuyToAppStore:(NSString *)goodsID;

@end
