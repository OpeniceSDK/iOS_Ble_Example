//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import OpeniceSDK
import SwiftUI

struct AlarmView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("闹钟模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                
                Button("获取闹钟") {
                    Task {
                        let result = await OpeniceSDK.shared.getAlarmClock()
                        print("获取闹钟 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置闹钟") {
                    Task {
                        let alarms: [AlarmItem] = [
                            AlarmItem(isOn: true, hour: 7, minute: 30, repeatWeek: .everyday), // 每天
                            AlarmItem(isOn: true, hour: 8, minute: 45, repeatWeek: .weekdays),  // 周一到周五
                            AlarmItem(isOn: true, hour: 1, minute: 45, repeatWeek: .monday)  // 周一
                        ]
                        let success = await OpeniceSDK.shared.setAlarmClock(alarms)
                        print("设置闹钟 success:", success)
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
