//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import OpeniceSDK
import SwiftUI

struct DeviceReportView: View {
    // 引用上面的 ViewModel
    @StateObject private var logger = DeviceLogViewModel()
    
    // 保存旧的代理，以便退出页面时恢复（可选）
    @State private var previousDelegate: OpeniceManagerDelegate?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // 顶部标题栏
            HStack {
                Text("设备指令监控台")
                    .font(.headline)
                Spacer()
                // 清屏按钮
                Button("清空") {
                    logger.logText = ""
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            
            // 日志显示区域
            ScrollView {
                Text(logger.logText)
                    .font(.system(.caption, design: .monospaced)) // 等宽字体看起来像代码
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            // 点击文本可以复制方便调试
            .textSelection(.enabled)
        }
        .onAppear {
            // 1. 进入页面：保存旧代理，设置当前 logger 为代理
            self.previousDelegate = OpeniceManager.shared.delegate
            OpeniceManager.shared.delegate = logger
            print("🟢 监控模式已开启")
        }
        .onDisappear {
            // 2. 离开页面：恢复原来的代理（比如 HomeViewController）
            OpeniceManager.shared.delegate = self.previousDelegate
            print("🔴 监控模式已关闭")
        }
    }
}
