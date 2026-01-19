//
//  DeviceSettingsView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import OpeniceSDK
import SwiftUI

struct DeviceSettingsView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    
    var body: some View {
        VStack {
            Text("设备设置模块内容")
                .font(.title2)
                .foregroundColor(.red)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("获取语言") {
                    Task {
                        let result = await OpeniceManager.shared.getLanguage()
                        print("获取语言 result:", result)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置语言") {
                    Task {
                        let success = await OpeniceManager.shared.setLanguage(.english)
                        print("设置语言 success:", success)
                    }
                }.buttonStyle(.bordered)
                
                
                Button("获取勿扰模式") {
                    Task {
                        let result = await OpeniceManager.shared.getNotDisturb()
                        print("获取勿扰模式 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置勿扰模式") {
                    Task {
                        let item = NotDisturbItem(
                            isEnabled: true,
                            startHour: 23,
                            startMinute: 0,
                            endHour: 7,
                            endMinute: 0,
                            repeatWeek: 0b0111110
                        )
                        let config = NotDisturbConfig(
                            isTotalEnabled: true,
                            items: [item]
                        )
                        let success = await OpeniceManager.shared.setNotDisturb(config)
                        print("设置勿扰模式 success:", success)
                    }
                }.buttonStyle(.bordered)
                
                Button("获取抬腕亮屏") {
                    Task {
                        let result = await OpeniceManager.shared.getAwaken()
                        print("获取抬腕亮屏 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置抬腕亮屏") {
                    Task {
                        let config = AwakenConfig(
                            state: .scheduled,
                            startHour: 8,
                            startMinute: 0,
                            stopHour: 22,
                            stopMinute: 0
                        )
                        let success = await OpeniceManager.shared.setAwaken(config)
                        print("设置抬腕亮屏 success:", success)
                    }
                }.buttonStyle(.bordered)
                
                Button("获取振动设置") {
                    Task {
                        let result = await OpeniceManager.shared.getVibrate()
                        print("获取振动设置 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置振动设置") {
                    Task {
                        let config = VibrateConfig(
                            strength: .medium,
                            isKeyVibrateEnabled: true,
                            isRemindVibrateEnabled: true,
                            isCrownVibrateEnabled: false
                        )
                        let success = await OpeniceManager.shared.setVibrate(config)
                        print("设置振动设置 success:", success)
                    }
                }.buttonStyle(.bordered)
                
                Button("获取显示设置") {
                    Task {
                        let result = await OpeniceManager.shared.getDisplay()
                        print("获取显示设置 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置显示设置") {
                    Task {
                        let config = DisplayConfig(
                            autoBrightness: true,
                            brightness: .level5,
                            screenRestTime: .seconds20,
                            constantBrightnessTime: .minutes20,
                            nightMode: true,
                            nightStartHour: 22,
                            nightStartMinute: 0,
                            nightEndHour: 7,
                            nightEndMinute: 0
                        )
                        let success = await OpeniceManager.shared.setDisplay(config)
                        print("设置显示设置 success:", success)
                    }
                }.buttonStyle(.bordered)
                
    
                Button("获取声音设置") {
                    Task {
                        let result = await OpeniceManager.shared.getVoice()
                        print("获取声音设置 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置声音设置") {
                    Task {
                        let config = VoiceConfig(
                            systemVolume: .level5,
                            callVolume: .level2,
                            sportVolume: .level4,
                            keyVoice: true,
                            systemTipVoice: true,
                            mute: false
                        )
                        let success = await OpeniceManager.shared.setVoice(config)
                        print("设置声音设置 success:", success)
                    }
                }.buttonStyle(.bordered)
                
                Button("同步用户信息") {
                    Task {

                        // 模拟数据
                        let mockUserProfile = UserInfoConfig(
                            year: 1995,
                            month: 8,
                            day: 15,
                            gender: .female,       // 女
                            height: 165,     // 165 cm
                            weight: 55000    // 55 kg -> 55000 g
                        )
                        let info = await OpeniceManager.shared.setUserInfo(mockUserProfile)
                        print("同步用户信息:", info as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("同步个人偏好") {
                    Task {
                        let config = UserPreferenceConfig(
                            heightUnit: .cm,
                            weightUnit: .kg,
                            temperatureUnit: .celsius,
                            distanceUnit: .km,
                            altitudeUnit: .meter,
                            weekStart: .monday,
                            timeFormat: .h12
                        )
                        let pref = await OpeniceManager.shared.setPreference(config)
                        print("同步个人偏好:", pref as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置经纬度") {
                    Task {
                        let success = await OpeniceManager.shared.setLocation(latitude: 39.9042,longitude: 116.4074)
                        print("设置经纬度 success:", success)
                    }
                }.buttonStyle(.bordered)
                
                Button("同步心率区间信") {
                    Task {
                        let config = HeartRateConfig(
                            heartRateMax: 157,
                            limitMin: 150,
                            limitMax: 160,
                            noOxygenMin: 155,
                            noOxygenMax: 175,
                            oxygenMin: 120,
                            oxygenMax: 140,
                            burnFatMin: 120,
                            burnFatMax: 130,
                            warmUpMin: 100,
                            warmUpMax: 110
                        )
                        let success = await OpeniceManager.shared.setHeartRateRange(defaultRange: config)
                        print("同步心率区间信 success:", success as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("获取连接提醒") {
                    Task {
                        let result = await OpeniceManager.shared.getBleConnectionReminder()
                        print("获取连接提醒 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("设置连接提醒") {
                    Task {
                        let success = await OpeniceManager.shared.setBleConnectionReminder(connect: false, disconnect: false)
                        print("设置连接提醒 success:", success)
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
