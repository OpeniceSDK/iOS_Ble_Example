//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import OpeniceSDK
import SwiftUI

struct MultimediaView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    
    var body: some View {
        VStack {
            Text("多媒体模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("获取电话提醒") {
                    Task {
                        let result = await OpeniceManager.shared.getPhoneRemind()
                        print("获取电话提醒 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置电话提醒") {
                    Task {
                        let success = await OpeniceManager.shared.setPhoneRemind(
                            isEnabled: false,
                            delaySeconds: 5
                        )
                        print("设置电话提醒 success:", success)
                    }
                }.buttonStyle(.bordered)
                Button("获取音乐开关") {
                    Task {
                        let enabled = await OpeniceManager.shared.getMusicControl()
                        print("获取音乐开关 enabled:", enabled)
                    }
                }
                .buttonStyle(.bordered)

                Button("设置音乐开关") {
                    Task {
                        let success = await OpeniceManager.shared.setMusicControl(enabled: true)
                        print("设置音乐开关 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                Button("同步短信回复") {
                    Task {
                        // 模拟数据：5条常用快捷回复
                        let templates = [
                            "好的，马上处理1",
                            "正在开会，稍后回复2",
                            "我现在不方便，稍后联系你3",
                            "好的，收到了4",
                            "谢谢5"
                        ]
                        
                        let success = await OpeniceManager.shared.syncQuickReply(templates: templates)
                        print("同步短信回复 success:", success)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
