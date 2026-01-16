//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct FemaleHealthView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("女性健康模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("同步女性健康") {
                    Task{
                        // 模拟数据
                        let config = WomanHealthConfig(
                            duration: 5,               // 经期持续5天
                            interval: 28,              // 经期周期28天
                            remindSwitch: true,        // 开启提醒
                            menstrualRemindDays: 2,    // 经期提前2天提醒
                            ovulationRemindDays: 1,    // 排卵日提前1天提醒
                            easyPregnancyRemindDays: 3,// 易孕期提前3天提醒
                            recentStartTime: 7*24*3600, // 最近一次经期开始时间：7天前
                            recentEndTime: 2*24*3600    // 最近一次经期结束时间：2天前
                        )
                        let result = await OpeniceSDK.shared.syncWomanHealthy(config)
                        print("同步女性健康 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
           
                Button("女性健康开关") {
                    Task{
                        let result = await OpeniceSDK.shared.syncWomanHealthyState(isShow: true)
                        print("女性健康功能 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
