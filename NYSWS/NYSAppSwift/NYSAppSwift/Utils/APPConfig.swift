//
//  APPConfig.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import Foundation

// 内测自动更新
let FirApiToken     :String      =        ""

// 极光推送
let JPUSH_APPKEY    :String      =        ""
let JPUSH_CHANNEl   :String      =        "App Store"
let IS_Prod         :Bool        =        true

// 微信登录
let WXAPPID         :String      =        ""
let APPSECRET       :String      =        ""

// 友盟+
let UMengKey        :String      =        ""

// pragma mark - APP Style

/// APP主题色
let NAppThemeColor  :UIColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "app_theme_color") as! UIColor
let NAppPImg        :UIImage = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "placeholder_image") as! UIImage
let NAppPImgFill    :UIImage = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "placeholder_image_fillet") as! UIImage

/// APP默认分页大小
let NAppPageSize :Int = 10

/// APP间隔
let NAppSpace:CGFloat = 15.0

/// APP圆角
let NAppRadius:CGFloat = 10.0

// pragma mark - UserDefaults Key
let kToken = "kToken"



