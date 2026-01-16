//
//  DeviceLogViewModel.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/12.
//

import OpeniceSDK
import SwiftUI
import Combine

class DeviceLogViewModel: NSObject, ObservableObject, OpeniceSDKDelegate {
    
    // 这里的文本用于在界面上显示
    @Published var logText: String = "等待设备指令...\n"
    
    // 日期格式化
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f
    }()
    
    // 通用日志添加方法
    private func appendLog(_ eventName: String, data: Any? = nil) {
        let time = formatter.string(from: Date())
        var newLog = "[\(time)] 📡 \(eventName)"
        
        if let d = data {
            newLog += "\n📦 数据: \(String(describing: d))"
        }
        
        newLog += "\n--------------------------\n"
        
        DispatchQueue.main.async {
            self.logText = newLog + self.logText
        }
    }
    
    // MARK: - OpeniceSDKDelegate 所有方法的实现
    func onFindPhone(isFind: Bool) {
        let status = isFind ? "开始" : "停止"
        appendLog("请求找手机 (\(status))")
    }
    
    func onUserInfoChanged(config: UserInfoConfig) {
        appendLog("用户信息变更", data: config.toDict)
    }
    
    func onPreferenceChanged(config: UserPreferenceConfig) {
        appendLog("偏好设置变更", data: config.toDict)
    }
    
    func onMenstrualPeriodChanged(config: WomanHealthConfig) {
        appendLog("生理期数据变更", data: config.toDict)
    }
    
    func onSportsDataUpdate() {
        appendLog("收到新运动数据通知 (无参数)")
    }
    
    func onRequestLocation() {
        Task {
            await OpeniceSDK.shared.responseLocation(latitude: 39.9042, longitude: 116.4074)
        }
        appendLog("设备请求 AGPS 定位")
    }
    
    func onHeartRateRangeChanged(data: [HeartRateConfig]) {
        appendLog("心率区间变更", data: data)
    }
    
    
    func onBatteryStatusChanged(level: Int, state: Int){
        appendLog("电量变更: \(level)%", data: state)
    }
    
    func onDeviceReset(secretKey: String) {
        appendLog("设备重置", data: secretKey)
    }
    
    func onDeviceAGPS(data: [String: Any]) {
        appendLog("获取AGPS", data: data)
    }
}
