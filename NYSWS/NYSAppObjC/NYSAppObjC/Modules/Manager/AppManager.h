//
//  AppManager.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/10.
//

#import <NYSUIKit/NYSUIKit.h>
#import "NYSUserInfo.h"

#define NAppManager   [AppManager sharedAppManager]
#define NAppUser      [AppManager sharedAppManager].userInfo

// Token缓存
#define NUserTokenKey               @"KUserTokenKey"
// 本地用户信息缓存
#define NUserInfoModelCache         @"KUserInfoModelCache"
// token过期时间戳
#define NTokenExpiredTimeStamp      @"KTokenExpiredTimeStamp"
// token过期时间校验
#define NIsCheckTokenExpired        NO

typedef NS_ENUM(NSInteger, NUserLoginType) {
    NUserLoginTypeUnKnow = 0,   // 未知
    NUserLoginTypeQQ,           // QQ登录
    NUserLoginTypeWeChat,       // 微信登录
    NUserLoginTypePwd,          // 密码登录
    NUserLoginTypeOncecode,     // 短信登录
    NUserLoginTypeApple,        // Sign In With Apple
    NUserLoginTypeVerification  // 一键认证
};

typedef void (^NYSLoginBlock)(BOOL success, id obj);
typedef void (^NYSLogoutBlock)(BOOL success, id obj);
typedef void (^NYSLoadUserInfoCompletion)(BOOL success, NYSUserInfo *userInfo, NSError *error);

@interface AppManager : NYSBaseObject

+ (AppManager *)sharedAppManager;

/** 当前用户信息 */
@property (nonatomic, strong) NYSUserInfo *userInfo;
/** 当前用户令牌 */
@property (nonatomic, strong) NSString *token;
/** 是否已登录 */
@property (nonatomic, assign) BOOL isLogined;
/** 请求序列号 */
@property (nonatomic, assign) NSInteger seq;

/// 网络状态
@property (assign, nonatomic) NSInteger netStatus;

/// 登录处理
/// @param loginType 登录方式
/// @param authInfo 鉴权信息
/// @param completion  登录完成回调
- (void)loginHandler:(NUserLoginType)loginType authInfo:(NYSAuthInfo *)authInfo completion:(NYSLoginBlock)completion;

/// 自动登录
/// @param completion 回调
- (void)autoLoginToServer:(NYSLoginBlock)completion;

/// 强制登出
- (void)onKick;

/// 退出登录
/// @param completion 回调
- (void)logout:(NYSLogoutBlock)completion;

/// 加载用户信息
- (void)loadUserInfoCompletion:(NYSLoadUserInfoCompletion)completion;
- (void)loadUserInfo:(NSString *)token completion:(NYSLoadUserInfoCompletion)completion;

/// 缓存已购课程数据
- (void)cacheAudioData:(BOOL)isShowProcess isRecache:(BOOL)isRecache;
@end
