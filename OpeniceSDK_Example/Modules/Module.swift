//
//  Module.swift
//  OpeniceManager_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import SwiftUI

/// 模块类型
public enum Module: String, CaseIterable, Identifiable {
    public var id: String { self.rawValue }

    case deviceInfo             = "设备信息与控制"
    case deviceSettings         = "设备设置"
    case weather                = "天气"
    case alarm                  = "闹钟"
    case contact                = "联系人"
    case femaleHealth           = "女性健康"
    case notification           = "通知"
    case watchFace              = "表盘"
    case healthMonitoring1      = "健康监测设置1"
    case healthMonitoring2      = "健康监测设置2"
    case multimedia             = "多媒体"
    case sports                 = "运动"
    case deviceReport           = "设备上报"
    case route                  = "路线"
    case ota                    = "OTA"
    case events                 = "提醒事项"
    case agps                   = "AGPS"
}
