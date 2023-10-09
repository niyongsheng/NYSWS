//
//  EMAppStorePay.m
//  MobileFixCar
//
//  Created by Wcting on 2018/4/11.
//  Copyright © 2018年 NYS. All rights reserved.
//

#import "EMAppStorePay.h"
#import <StoreKit/StoreKit.h>

@interface EMAppStorePay()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, strong)NSString *goodsId;/**<wct20180420  商品id*/

@end

@implementation EMAppStorePay

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];// 4.设置支付服务
    }
    return self;
}
//结束后一定要销毁
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - public
-(void)starBuyToAppStore:(NSString *)goodsID
{
    if ([SKPaymentQueue canMakePayments]) {//5.判断app是否允许apple支付
      
        [self getRequestAppleProduct:goodsID];// 6.请求苹果后台商品
        
    } else {
        [NYSTools showToast:@"当前设备不支持购买"];
    }
}

#pragma mark - private
#pragma mark ------ 请求苹果商品
- (void)getRequestAppleProduct:(NSString *)goodsID
{
    self.goodsId = goodsID;//把前面传过来的商品id记录一下，下面要用
    // 7.这里的com.czchat.CZChat01就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
    NSArray *product = [[NSArray alloc] initWithObjects:goodsID,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    
    //SKProductsRequest参考链接：https://developer.apple.com/documentation/storekit/skproductsrequest
    //SKProductsRequest 一个对象，可以从App Store检索有关指定产品列表的本地化信息。
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];// 8.初始化请求
    request.delegate = self;
    [request start];// 9.开始请求
}
#pragma mark ------ 支付完成
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    //此时告诉后台交易成功，并把receipt传给后台验证
    NSString *transactionReceiptString= nil;
    // 系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURLRequest *appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSError *error = nil;
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
    // 20 BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性 21 BASE64是可以编码和解码的 22
    transactionReceiptString = [receiptData base64EncodedStringWithOptions:0];//[receiptData base64EncodedStringWithOptions:0];
    NLog(@"requestContentstr:%@",transactionReceiptString);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EMAppStorePay:responseAppStorePaySuccess:error:)]) {
        [self.delegate EMAppStorePay:self responseAppStorePaySuccess:@{@"value":transactionReceiptString} error:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - delegate
#pragma mark ------ SKProductsRequestDelegate
// 10.接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    
    if ([product count] == 0) {//如果服务器没有产品
        [NYSTools showToast:@"没有找到对应的商品"];
        return;
    }
    
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in product) {
        NLog(@"%@", [pro description]);
        NLog(@"%@", [pro localizedTitle]);
        NLog(@"%@", [pro localizedDescription]);
        NLog(@"%@", [pro price]);
        NLog(@"%@", [pro productIdentifier]);
        // 11.如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if([pro.productIdentifier isEqualToString:self.goodsId]){
            requestProduct = pro;
        }
    }
    // 12.发送购买请求，创建票据  这个时候就会有弹框了
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];//将票据加入到交易队列
}

#pragma mark ------ SKRequestDelegate (@protocol SKProductsRequestDelegate <SKRequestDelegate>)
// 请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NLog(@"error:%@", error);
}
// 反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request
{
    NLog(@"信息反馈结束");
}

    
#pragma mark ------ SKPaymentTransactionObserver 监听购买结果
// 13.监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(EMAppStorePay:responseAppStorePayStatusshow:error:)]) {
        [self.delegate EMAppStorePay:self responseAppStorePayStatusshow:@{@"value":transaction} error:nil];
    }

    for (SKPaymentTransaction *tran in transaction) {

        NLog(@"%@",tran.payment.applicationUsername);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NLog(@"交易完成");
                [self completeTransaction:tran];
            }
                break;
                
            case SKPaymentTransactionStatePurchasing:
                NLog(@"商品添加进列表");
                break;
                
            case SKPaymentTransactionStateRestored:
                NLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
                
            case SKPaymentTransactionStateFailed:
                NLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
                
            case SKPaymentTransactionStateDeferred:
                NLog(@"交易还在队列里面，但最终状态还没有决定");
                break;
                
            default:
                break;
        }
        
    }

    
}

@end
