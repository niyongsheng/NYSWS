//
//  APPConfig.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import Foundation

// 内测自动更新
let FirApiToken     :String      =        ""

// 极光推送
let JPUSH_APPKEY    :String      =        ""
let JPUSH_CHANNEl   :String      =        "App Store"
let IS_Prod         :Bool        =        true

// 高德地图
let AMAP_APPKEY     :String      =        ""
let AMAP_SECRET     :String      =        ""

// 微信登录
let WXAPPID         :String      =        ""
let APPSECRET       :String      =        ""

// 友盟+
let UMengKey        :String      =        ""

// 默认分页大小
let DefaultPageSize :Int         =        10

let NAppThemeColor  :UIColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "app_theme_color") as! UIColor

