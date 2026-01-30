//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct HealthMonitoringView1: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]

    var body: some View {
        VStack {
            Text("健康监测模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("获取健康设置") {
                    Task {
                        let success = await OpeniceManager.shared.getHealthSetting()
                        print("获取健康设置 success:", success as Any)
                    }
                }
                .buttonStyle(.bordered)
                Button("设置心率检测") {
                    Task {
                        // 模拟数据：开启自动检测，30分钟一次，报警阈值 40-180
                        let config = HeartRateDetectionConfig(
                            autoDetection: true,
                            interval: 30,
                            minHeartRate: 40,
                            maxHeartRate: 180
                        )
                        let success = await OpeniceManager.shared.setHeartRateDetection(config)
                        print("设置心率检测 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("设置血氧检测") {
                    Task {
                        // 模拟数据：开启检测，开启报警，低血氧阈值90%，60分钟一次
                        let config = BloodOxygenDetectionConfig(
                            autoDetection: true,
                            minBloodOxygenAlarm: true,
                            minBloodOxygen: 90,
                            interval: 60
                        )
                        let success = await OpeniceManager.shared.setBloodOxygenDetection(config)
                        print("设置血氧检测 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                Button("设置喝水提醒") {
                    Task {
                        // 模拟数据：早9晚6，每60分钟提醒，周一到周五(31 -> 00011111)
                        let config = DrinkWaterConfig(
                            clockSwitch: true,
                            interval: 60,
                            startHour: 9, startMin: 0,
                            endHour: 18, endMin: 0,
                            repeatWeek: [.friday, .monday]
                        )
                        let success = await OpeniceManager.shared.setDrinkClock(config)
                        print("设置喝水提醒 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("设置久坐提醒") {
                    Task {
                        // 模拟数据：午休开启(12:00-14:00)，每小时少于100步则提醒
                        let config = SedentaryClockConfig(
                            clockSwitch: true,
                            steps: 100,
                            startHour: 9,
                            startMin: 0,
                            endHour: 18, endMin: 0,
                            repeatWeek: .everyday // 每天
                        )
                        let success = await OpeniceManager.shared.setSedentaryClock(config)
                        print("设置久坐提醒 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("开启科学睡眠") {
                    Task {
                        let success = await OpeniceManager.shared.setScientificSleep(switchState: true)
                        print("设置科学睡眠 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("设置三环目标") {
                    Task {
                        let config = HealthyThreeRingsConfig(
                            activity: 600,
                            exercise: 60,
                            walking: 22,
                            steps: 5000,
                            distance: 3000
                        )
                        let success = await OpeniceManager.shared.setHealthyThreeRings(config)
                        print("设置三环目标 success:", success)
                    }
                }
                .buttonStyle(.bordered)
                Button("获取三环目标") {
                    Task {
                        let success = await OpeniceManager.shared.getHealthyThreeRings()
                        print("获取三环目标 success:", success as Any)
                    }
                }
                .buttonStyle(.bordered)
                Button("同步历史睡眠") {
                    Task {
                        let now = Int(Date().timeIntervalSince1970 * 1000)
                        let success = await OpeniceManager.shared.syncHistorySleep(time: now)
                        print("同步历史睡眠 success:", success as Any)
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
        }
    }
    
}


