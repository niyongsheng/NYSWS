
#ifndef CommonMacros_h
#define CommonMacros_h

#pragma mark -- 网络相关 --
#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

#if DevelopSever
/** 接口前缀-开发服务器*/
static NSString *const APP_CONTENT_PATH     = @"";
static NSString *const APP_BASE_URL         = @"http://dev.app.cn";
static NSString *const APP_CDN_URL          = @"http://cdn.app.cn";
static NSString *const APP_FEEDBACK_URL     = @"";
#elif TestSever
/** 接口前缀-测试服务器*/
static NSString *const APP_CONTENT_PATH     = @"";
static NSString *const APP_BASE_URL         = @"";
static NSString *const APP_CDN_URL          = @"";
static NSString *const APP_FEEDBACK_URL     = @"";
#elif ProductSever
/** 接口前缀-生产服务器*/
static NSString *const APP_CONTENT_PATH     = @"";
static NSString *const APP_BASE_URL         = @"";
static NSString *const APP_CDN_URL          = @"";
static NSString *const APP_FEEDBACK_URL     = @"";
#endif

#define AppOfficialWebsite      [NSString stringWithFormat:@"%@%@", APP_BASE_URL, @"/aboutus.html"]
#define AppServiceAgreement     [NSString stringWithFormat:@"%@%@", APP_BASE_URL, @"/xieyi.html"]
#define AppPrivacyAgreement     [NSString stringWithFormat:@"%@%@", APP_BASE_URL, @"/yinsi.html"]

// 网络url
#define NCDNURL(urlStr)  [urlStr containsString:@"http"] ? [NSURL URLWithString:urlStr] : [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APP_CDN_URL, urlStr]]

#pragma mark -- 用户相关 --
// 登录状态改变通知
#define NNotificationLoginStateChange           @"NNotificationLoginStateChange"
// 自动登录成功
#define NNotificationAutoLoginSuccess           @"KNotificationAutoLoginSuccess"
// 被踢下线
#define NNotificationOnKick                     @"KNotificationOnKick"

#pragma mark -- APP相关 --
// 切换默认房产
#define NNotificationChangeDefaultBuilding      @"NNotificationChangeDefaultBuilding"
// 刷新用户信息
#define NNotificationReloadUserDetailInfo       @"NNotificationReloadUserDetailInfo"

#pragma mark -- 第三方平台相关 --
// Company Name
#define CompanyName     @"NYS Studio"
// App Store ID
#define APPID           @"6443611777"
// App Store详情页
#define AppStoreURL     [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", APPID]
// App APIs
#define AppAPIsURL      [NSString stringWithFormat:@"%@%@/swagger-ui.html", APP_BASE_URL, APP_CONTENT_PATH]
// 机构编码
#define OrganizationID  @"c3485b27-4b20-53a3-8f81-07c03a9f949b"
// 外部链接
#define ExternalUrl     @"https://github.com/niyongsheng/NYSWS"
#define NYSPagesUrl     @"https://niyongsheng.github.io"

// 小鹅通
#define DefaultClientId  @"" // client ID
#define DefaultAppId     @"" // 店铺 ID
#define DefaultSecretKey @"" // 小鹅通申请的秘钥
#define DefaultSourceUrl @"https://app.h5.xiaoeknow.com" //小鹅店铺首页链接

// 内测自动更新
#define FirApiToken             @""

// 微信登录
#define WXAPPID                 @""
#define APPSECRET               @""

// 支付宝
#define AILIPAY_ID              @""
#define AILIPAY_SECRET          @""

// QQ登录
#define QQAPPID                 @""
#define QQAPPKEY                @""

// 极光推送
#define JPUSH_APPKEY            @""
#define JPUSH_CHANNEl           @"App Store"
#define IS_Prod                 YES

// 友盟+
#define UMengKey                @""

// 兔小巢
#define TXCAppID                @""

// 融云IM
#define RCAPPKEY_DEV            @"" // 开发环境
#define RCAPPKEY_PRO            @"" // 生产环境

#endif /* CommonMacros_h */
