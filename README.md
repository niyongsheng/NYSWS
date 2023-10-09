![(logo)](./logo.png)
NYSWS
===
![Pages](https://img.shields.io/badge/NYSWS-1.0.0-brightgreen.svg?style=flat-square)
===
> ios简洁的组件化方案架构。<br>
> ios simple componentized solution framework.

<!-- ## APP
------------ 
<img src="./home.png" width="125" height="270">  -->


## Architecture
```text
NYSWS
├─ NYSAppObjC
│    └─ NYSAppObjC(oc项目)
│    
├─ NYSAppSwift
│    └─ NYSAppSwift(swift项目)
│    
├─ NYSKit
│    ├─ NYSKit
│    │    ├─ Modules
│    │    ├─ NYSKit.h
│    │    └─ PublicHeader.h
│    └─ NYSKit.xcodeproj
│           ├─ project.pbxproj
│           └─ xcuserdata
├─ NYSUIKit
│    ├─ NYSUIKit
│    │    ├─ BaseClass
│    │    ├─ Category
│    │    ├─ Manager
│    │    ├─ NYSUIKit.h
│    │    ├─ PublicHeader.h
│    │    ├─ Resources
│    │    ├─ UI
│    │    └─ Utilities
│    └─ NYSUIKit.xcodeproj
│           ├─ project.pbxproj
│           └─ xcuserdata
├─ NYSWS.xcworkspace
├─ Podfile
└─ Pods
```

## Podfile
```ruby
platform :ios, '13.0'
inhibit_all_warnings!

workspace './NYSWS.xcworkspace'
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://gitee.com/mirrors/CocoaPods-Specs.git'

# 项目公共依赖
def commonPods
  pod 'YYKit', '1.0.9'
end

# Swift 项目
target 'NYSAppSwift' do project './NYSAppSwift/NYSAppSwift.xcodeproj'
  
  commonPods
  pod 'FMDB', '2.7.5'
  pod 'YYKit', '1.0.9'
  pod 'FlexLib', '3.1.6'
  pod 'FFPopup', '1.1.5'
  pod 'XHLaunchAd', '3.9.12'
  pod 'WRNavigationBar', '1.4.0'
  pod 'SGQRCode', '4.1.0'
  pod 'BRPickerView', '2.8.0'
  pod 'IQKeyboardManagerSwift', '6.5.11'
  pod 'ZLPhotoBrowser', '4.4.0'
  
end

# Object-C 项目
target 'NYSAppObjC' do project './NYSAppObjC/NYSAppObjC.xcodeproj'
  use_frameworks! :linkage => :static
  
  commonPods
  pod 'FMDB', '2.7.5'
  pod 'Masonry', '1.1.0'
  pod 'FlexLib', '3.1.6'
  pod 'FFPopup', '1.1.5'
  pod 'XHLaunchAd', '3.9.12'
  pod 'ReactiveObjC', '3.1.1'
  pod 'WRNavigationBar', '1.4.0'
  pod 'SGQRCode', '4.1.0'
  pod 'BRPickerView', '2.8.0'
  pod 'IQKeyboardManager', '6.5.11'
  pod 'ZLPhotoBrowser-objc', '1.0.4'
  pod 'WMZBanner', '1.2.0'
  pod 'SGPagingView', '1.7.2'
  pod 'MBProgressHUD', '1.2.0'
  pod 'JDStatusBarNotification'
  
  pod 'JPush', '3.7.4'
  pod 'UMDevice'
  pod 'UMAPM'
  pod 'UMCCommon'
  pod 'UMCCommonLog', '2.0.2'
  pod 'WechatOpenSDK', '2.0.2'
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
  
end

# UI Framework
target 'NYSUIKit' do project './NYSUIKit/NYSUIKit.xcodeproj'
  pod 'MJRefresh', '3.7.5'
  pod 'AFNetworking', '4.0.1'
  pod 'SVProgressHUD', '2.2.5'
  pod 'DZNEmptyDataSet', '1.8.1'
end

# Core Framework
target 'NYSKit' do project './NYSKit/NYSKit.xcodeproj'
  pod 'AFNetworking', '4.0.1'
  pod 'SVProgressHUD', '2.2.5'
end

```

## apple-app-site-association
```json
{
    "webcredentials": {
        "apps": [
		          "F9J739W8Y4.com.ios.nysws"
                ]
    },
    "applinks": {
        "apps": [],
        "details": [
            {
                "appID": "F9J739W8Y4.com.ios.nysws",
                "paths": [ "*" ]
            }
        ]
    }
}
```

## AppDelegate
```object-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化友盟统计
    [self initUMeng];
    
    // 初始化网络
    [self initNetwork];
    
    // 初始化window
    [self initWindow];
      
    // 初始化app服务
    [self initService];
    
    // 初始化导航栏样式
    [self initNavBar];
    
    // 初始化 IQKM
    [self initIQKeyboardManager];
    
    // 初始化主题
    [[ThemeManager sharedThemeManager] configTheme];
    
    // 初始化极光推送
    [self initPush:launchOptions application:application];

    // 初始化微信SDK
    [self initWXApi:launchOptions application:application];
    
    return YES;
}
```

## Contact Me
* E-mail: niyongsheng@Outlook.com
* Weibo: [@Ni永胜](https://weibo.com/u/7317805089)
