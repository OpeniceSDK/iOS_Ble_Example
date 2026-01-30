//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import SwiftUI
import OpeniceSDK

struct DeviceInfoView: View {
    let currentDevice = DeviceStorage.shared.load()
    
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    
    var body: some View {
        VStack {
            Text("设备信息与控制内容")
                .font(.title2)
                .foregroundColor(.red)
        
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("找到手表") {
                    Task { await OpeniceManager.shared.findWatch(start: true) }
                }
                .buttonStyle(.bordered)
                Button("停止寻找") {
                    Task { await OpeniceManager.shared.findWatch(start: false) }
                }
                .buttonStyle(.bordered)
                Button("获取设备信息") {
                    Task {
                        let secretKey = String(currentDevice?.secretKey ?? "")
                        let result = await OpeniceManager.shared.getDeviceInfo(secretKey: secretKey)
                        print("设备信息:", result)
                    }
                }
                .buttonStyle(.bordered)
          
                Button("重启设备") {
                    Task { await OpeniceManager.shared.restartDevice() }
                }
                .buttonStyle(.bordered)
                
                Button("恢复出厂设置") {
                    Task {
                        let secretKey = String(currentDevice?.secretKey ?? "")
                        let _ = await OpeniceManager.shared.resetDevice(secretKey: secretKey)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("同步时间") {
                    Task {
                        let calendar = Calendar.current
                        let dateAt11 = calendar.date(
                            bySettingHour: 11,
                            minute: 0,
                            second: 0,
                            of: Date()
                        )!
                        let _ =  await OpeniceManager.shared.syncTime(date: dateAt11)
                    }
                }
                .buttonStyle(.bordered)
    
                Button("获取世界时钟") {
                    Task{
                        let result = await OpeniceManager.shared.getWorldTimes()
                        print("获取世界时钟 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                Button("设置世界时钟") {
                    Task{
                        let cities: [WorldTimeItem] = [
                            WorldTimeItem(id: 1, zone: 86, cityName: "北京"),
                            WorldTimeItem(id: 2, zone: 86, cityName: "上海"),
                            WorldTimeItem(id: 3, zone: 86, cityName: "广州")
                        ]
                        let result = await OpeniceManager.shared.setWorldTimes(cities)
                        print("设置世界时钟 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
