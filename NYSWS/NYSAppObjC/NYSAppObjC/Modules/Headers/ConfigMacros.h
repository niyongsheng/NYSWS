
#ifndef CommonMacros_h
#define CommonMacros_h

#pragma mark -- 网络相关 --
#define DevelopSever 0
#define TestSever    0
#define ProductSever 1

#if DevelopSever
/** 接口前缀-开发服务器*/
static NSString *const APP_CONTENT_PATH     = @"";
static NSString *const APP_BASE_URL         = @"https://xiaoluht.app12345.cn";
static NSString *const APP_CDN_URL          = @"";
static NSString *const APP_FEEDBACK_URL     = @"";
#elif TestSever
/** 接口前缀-测试服务器*/
static NSString *const APP_CONTENT_PATH     = @"";
static NSString *const APP_BASE_URL         = @"https://xiaoluht.app12345.cn";
static NSString *const APP_CDN_URL          = @"";
static NSString *const APP_FEEDBACK_URL     = @"";
#elif ProductSever
/** 接口前缀-生产服务器*/
static NSString *const APP_CONTENT_PATH     = @"";
static NSString *const APP_BASE_URL         = @"https://xiaolu.sdcrxlw.cn";
static NSString *const APP_CDN_URL          = @"";
static NSString *const APP_FEEDBACK_URL     = @"";
#endif

#define AppOfficialWebsite      @"https://xiaolu.sdcrxlw.cn/aboutus.html"
#define AppServiceAgreement     @"https://xiaolu.sdcrxlw.cn/xieyi.html"
#define AppPrivacyAgreement     @"https://xiaolu.sdcrxlw.cn/yinsi.html"

#define DefaultClientId  @"xopY5z6Ge8H2201" // client ID
#define DefaultAppId     @"app5wtzrduk4143" // 店铺 ID
#define DefaultSecretKey @"LOtdlYWOUz9uZVbsxF4CmMdPJ8F9PAFG" // 小鹅通申请的秘钥
#define DefaultSourceUrl @"https://app5wtzrduk4143.h5.xiaoeknow.com" //小鹅店铺首页链接

// 网络url
#define NCDNURL(urlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APP_CDN_URL, urlStr]]
// 网络状态变化
#define NNotificationNetWorkStateChange         @"KNotificationNetWorkStateChange"
// 基类生命周期变化
#define NNotificationBCViewWillAppear           @"KNNotificationBCViewWillAppear"
#define NNotificationBCViewDidAppear            @"KNNotificationBCViewDidAppear"

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
#define CompanyName     @"硕鼠工作室"
// App Store ID
#define APPID           @"6443611778"
// App Store详情页
#define AppStoreURL     [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", APPID]
// App APIs
#define AppAPIsURL      [NSString stringWithFormat:@"%@%@/swagger-ui.html", APP_BASE_URL, APP_CONTENT_PATH]
// 机构编码
#define OrganizationID  @"c3485b27-4b20-53a3-8f81-07c03a9f949b"

// 微信登录
#define WXAPPID         @""
#define APPSECRET       @""

// QQ登录
#define QQAPPID         @""
#define QQAPPKEY        @""

// 极光推送
#define JPUSH_APPKEY    @""
#define JPUSH_CHANNEl   @"App Store"
#define IS_Prod         YES

// 友盟+
#define UMengKey        @"63ad31dcd64e6861390988c9"

// 兔小巢
#define TXCAppID        @"344558"

// 融云IM
#define RCAPPKEY_DEV    @"n19jmcy5n8fz9" // 开发环境
#define RCAPPKEY_PRO    @"" // 生产环境

#endif /* CommonMacros_h */
