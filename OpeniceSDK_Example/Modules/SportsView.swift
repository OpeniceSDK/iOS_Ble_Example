//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct SportsView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("运动模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("设置运动") {
                    Task{
                        let config = SportsSettingConfig(
                            tipVolume: 5,               // 音量设置为中等
                            screenOn: true,                // 开启屏幕常亮
                            autoIdentifyMotion: true,      // 开启自动识别运动
                            maxHeartRateAlarm: true,       // 开启心率上限预警
                            maxHeartRate: 180           // 设置心率上限为 180 次/分
                        )
                        let result = await OpeniceManager.shared.setSportsSetting(config)
                        print("设置运动 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("获取运动设置") {
                    Task{
                        let result = await OpeniceManager.shared.getSportsSetting()
                        print("获取运动设置 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("同步运动记录") {
                    Task{
                        var allRecords: [BleSportsHeaderConfig] = []
                        while true {
                            let (code, record) = await OpeniceManager.shared.getSportsRecord()
                
                            if let item = record {
                                print("📦 收到记录: \(item.recordId)")
                                allRecords.append(item)
                            } else {
                                if code == 0 {
                                    print("✅ 同步正常完成 (共 \(allRecords.count) 条)")
                                } else {
                                    print("❌ 同步异常中断 (错误码: \(code))")
                                }
                                break
                            }
                        }
                        print("🎉 最终获取到 \(allRecords.count) 条记录")
                    }
                }.buttonStyle(.bordered)
                Button("设置运动推送") {
                    Task{
                        let result = await OpeniceManager.shared.sportsPushSet(.baseball)
                        print("设置运动推送 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
