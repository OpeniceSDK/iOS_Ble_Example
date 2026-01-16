//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import OpeniceSDK
import SwiftUI

struct NotificationView : View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    
    var body: some View {
        VStack {
            Text("通知模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("获取应用通知") {
                    Task{
                        let result = await OpeniceSDK.shared.getNotifications()
                        print("获取应用通知 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                Button("设置应用通知") {
                    Task{
                        let config = NotificationConfig(
                            totalSwitch: false,
                            otherSwitch: false,
                            appList: [.wechat, .qq]
                        )
                        let success = await OpeniceSDK.shared.setNotifications(config)
                        print("设置应用通知 success: \(success)")
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
