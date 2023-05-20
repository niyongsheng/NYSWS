//
//  FIRVersionCheck.m
//  QDYY
//
//  Created by niyongsheng on 2022/10/11.
//

#import <UIKit/UIKit.h>
#import "FIRVersionCheck.h"

@interface FIRVersionCheck()<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *firAppID;
@property (nonatomic, copy) NSString *firAPIToken;
@property (nonatomic, copy) NSString *updateURL;

@end

@implementation FIRVersionCheck

+ (instancetype)sharedInstance {
    static FIRVersionCheck *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FIRVersionCheck alloc] init];
    });
    return sharedInstance;
}

+ (void)setAPIToken:(NSString *)APIToken {
    [FIRVersionCheck sharedInstance].firAPIToken = APIToken;
}

+ (void)setAppID:(NSString *)appID APIToken:(NSString *)APIToken {
    [FIRVersionCheck sharedInstance].firAppID = appID;
    [FIRVersionCheck sharedInstance].firAPIToken = APIToken;
}

+ (void)check{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *idString = [FIRVersionCheck sharedInstance].firAppID;
    if (!idString) {
        idString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    }
    NSString *apiToken = [FIRVersionCheck sharedInstance].firAPIToken;
    NSString *idUrlString = [NSString stringWithFormat:@"http://api.bq04.com/apps/latest/%@?api_token=%@",idString,apiToken];
    NSURL *requestURL = [NSURL URLWithString:idUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"FIR - 新版本检测失败!");
        }else {
            NSError *jsonError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError && [object isKindOfClass:[NSDictionary class]]) {
                NSString *code = object[@"code"];
                NSString *errors = object[@"errors"];
                
                if (code && errors) {
                    NSLog(@"FIR - 新版本检测失败! (%@,%@)", code, errors);
                } else {
                    NSString *version = object[@"version"];
                    NSString *versionShort = object[@"versionShort"];
                    NSString *build = object[@"build"];
                    NSString *changelog = object[@"changelog"];
                    NSString *update_url = object[@"update_url"];
                    
                    [FIRVersionCheck sharedInstance].updateURL = update_url;
                    NSString *currentBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
                    NSLog(@"FIR － 检测到新版本 v%@(%@) ",version,build);
                    NSLog(@"FIR － 更新内容: \n%@ ",changelog);
                    
                    int relt = [self convertVersion:versionShort v2:appVersion];
                    if (relt == 1) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:changelog delegate:[FIRVersionCheck sharedInstance] cancelButtonTitle:@"暂不更新" otherButtonTitles:@"前去更新", nil];
                        [alertView show];
                        
                    } else if (relt == 0) {
                        if ([build integerValue] > [currentBuild integerValue]) {
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:changelog delegate:[FIRVersionCheck sharedInstance] cancelButtonTitle:@"暂不更新" otherButtonTitles:@"前去更新", nil];
                            [alertView show];
                        }
                    }
                }
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && self.updateURL) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateURL]];
    }
}

/**
比较版本号
@param v1 版本1
@param v2 版本2
@return 返回0:相等 1:v1>v2 -1:v1<v2
*/
+ (int)convertVersion:(NSString *)v1 v2:(NSString *)v2 {
   // 去除杂质，只留下数字和点
   NSString *v1_n = [[v1 componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
   NSString *v2_n = [[v2 componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
   
   // 分解成数组
   NSArray *v1_arr = [v1_n componentsSeparatedByString:@"."];
   NSArray *v2_arr = [v2_n componentsSeparatedByString:@"."];
   
   // 取数组最大值
   NSInteger count = MAX(v1_arr.count, v2_arr.count);
   for (NSInteger i = 0; i < count; i++) {
       
       NSInteger v1_i = 0;
       NSInteger v2_i = 0;
       
       if (v1_arr.count > i) {
           v1_i = [v1_arr[i] integerValue];
       }
       if (v2_arr.count > i) {
           v2_i = [v2_arr[i] integerValue];
       }
       
       // 按顺序比较大小
       if (v1_i != v2_i) {
           return v1_i>v2_i?1:-1;
       }
   }
   // 循环结束，返回相等
   return 0;
}

@end
