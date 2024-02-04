![(logo)](./logo.png)
NYSWS
===
![Pages](https://img.shields.io/badge/NYSWS-1.0.0-brightgreen.svg?style=flat-square)
===
> ios简洁的组件化方案架构。<br>
> ios simple componentized solution [framework](https://github.com/niyongsheng/NYSKit).

## APP
`pod分支以Cocoapod方式构建` https://github.com/niyongsheng/NYSWS/tree/pod/NYSWS

`main分支以Framework方式构建` https://github.com/niyongsheng/NYSWS/tree/main/NYSWS

- [OC示例项目](https://github.com/niyongsheng/NYSWS/tree/pod/NYSWS/NYSAppObjC/NYSAppObjC)
- [Swift示例项目](https://github.com/niyongsheng/NYSWS/tree/pod/NYSWS/NYSAppSwift/NYSAppSwift)

<img src="./images/swift_one_light.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_two_light.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_three_light.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_four_light.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_login_light.PNG" width="200" style="border-radius: 15px;"> 
--- | --- | --- | --- | ---
<img src="./images/swift_one_dark.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_two_dark.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_three_dark.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_four_dark.PNG" width="200" style="border-radius: 15px;"> | <img src="./images/swift_login_dark.PNG" width="200" style="border-radius: 15px;"> 

## Architecture
```text
NYSWS
├─ NYSAppObjC
│    └─ NYSAppObjC(obj_c示例项目)
│    
├─ NYSAppSwift
│    └─ NYSAppSwift(swift示例项目)
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

## Contact Me
* E-mail: niyongsheng@Outlook.com
* Weibo: [@Ni永胜](https://weibo.com/u/7317805089)
