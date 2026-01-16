//
//  HomePageView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2025/12/30.
//

import SwiftUI
import OpeniceSDK


struct HomePageView: View {
    @Binding var isBound: Bool
    // 可以从本地读取设备信息显示
    let currentDevice = DeviceStorage.shared.load()
    @State private var selectedModule: Module = .deviceInfo
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    
    var body: some View {
        ScrollView{
            VStack() {
                
                if let device = currentDevice {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("名称: \(device.name)")
                        Text("UUID: \(device.deviceId)")
                        Text("MAC: \(device.mac)")
                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                FlowLayout(spacing: 12, lineSpacing: 12) {
                    ForEach(Module.allCases) { module in
                        Button(action: {
                            withAnimation(.easeInOut) {
                                selectedModule = module
                            }
                        }) {
                            Text(module.rawValue)
                                .font(.subheadline)
                                .foregroundColor(selectedModule == module ? .white : .blue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(selectedModule == module ? Color.blue : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                // 模块内容显示
                Group {
                    switch selectedModule {
                    case .deviceInfo:
                        DeviceInfoView()
                    case .deviceSettings:
                        DeviceSettingsView()
                    case .weather:
                        WeatherView()
                    case .alarm:
                        AlarmView()
                    case .contact:
                        ContactView()
                    case .femaleHealth:
                        FemaleHealthView()
                    case .notification:
                        NotificationView()
                    case .watchFace:
                        WatchFaceView()
                    case .healthMonitoring1:
                        HealthMonitoringView1()
                    case .healthMonitoring2:
                        HealthMonitoringView2()
                    case .multimedia:
                        MultimediaView()
                    case .sports:
                        SportsView()
                    case .deviceReport:
                        DeviceReportView()
              
                    case .route:
                        RouteView()
                    case .ota:
                        OTAView()
                    case .events:
                        EventsView()
                    case .agps:
                        AGPSView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding()
                Spacer()
                Button("解除绑定") {
                    unbind()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }.padding()
        }.task {
            await autoConnect()
        }
    }
    
    // 自动连接
    private func autoConnect() async {
        guard let savedDevice = currentDevice else { return }

        let success: Bool = await OpeniceSDK.shared.reconnect(savedDevice.deviceId)
        await MainActor.run {
            if success {
                print("✅ 连接成功，切换界面")
            } else {
                print("❌ 连接失败 (可能是蓝牙断开或超时)")
                withAnimation {
                    isBound = false
                }
            }
        }
        
    }
    
    private func unbind() {
        Task {
            guard let savedDevice = currentDevice else { return }
            // 2. 执行异步解绑 (此时会等待 SDK 的 return)
            let isSuccess = await OpeniceSDK.shared.unBind(secretKey: savedDevice.secretKey)
            
            // 3. 回到主线程更新 UI
            await MainActor.run {
                if isSuccess {
                    print("✅ 解绑成功，切换界面")
                    withAnimation {
                        isBound = false
                    }
                } else {
                    print("❌ 解绑失败 (可能是蓝牙断开或超时)")
                }
            }
        }
    }
}
