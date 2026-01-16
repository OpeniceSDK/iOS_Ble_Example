//
//  OpeniceSDK_ExampleApp.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2025/12/24.
//

import SwiftUI
import OpeniceSDK

@main
struct OpeniceSDK_ExampleApp: App {
    // 核心状态：是否已绑定设备
    @State private var isBound: Bool = DeviceStorage.shared.load() != nil

    var body: some Scene {
        WindowGroup {
            // 根据状态动态切换根视图
            if isBound {
                HomePageView(isBound: $isBound)
                    .transition(.opacity)
            } else {
                ContentView(isBound: $isBound)
                    .transition(.opacity)
            }
        }
    }
}
