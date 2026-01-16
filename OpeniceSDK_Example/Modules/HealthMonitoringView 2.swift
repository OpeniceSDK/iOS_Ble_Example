//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct HealthMonitoringView2: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    private let dataTypes: [HealthDataType] = [
        .steps,
        .distance,
        .calories,
        .heartRate,
        .restingHeartRate,
        .activeHours,
        .exercise,
        .bloodOxygen,
        .hrv,
        .trainingLoad
    ]
    
    var body: some View {
        VStack {
            Text("健康监测模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(dataTypes, id: \.self) { type in
                    VStack(spacing: 8) {
                        // 标题
                        Text(getTitle(for: type))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 8) {
                            // 1. 当天按钮
                            Button("当天") {
                                Task {
                                    print("🔵 同步当天 [\(getTitle(for: type))]...")
                                    let list = await OpeniceSDK.shared.syncHealthData(type, mode: .sameday)
                                    print("   结果: \(list?.count ?? 0) 条")
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                            
                            // 2. 历史按钮 (训练负荷没有历史，隐藏)
                            if type != .trainingLoad {
                                Button("历史") {
                                    Task {
                                        print("🟠 同步历史 [\(getTitle(for: type))]...")
                                        let now = Int(Date().timeIntervalSince1970 * 1000)
                                        let list = await OpeniceSDK.shared.syncHealthData(type, mode: .history(time: now))
                                        print("   结果: \(list?.count ?? 0) 条")
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(.orange)
                                .controlSize(.mini)
                            } else {
                                // 占位，保持排版一致
                                Color.clear
                                    .frame(width: 40, height: 1)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.1)) // 给每个卡片加个浅灰色背景
                    .cornerRadius(8)}
            }
            .padding()
            
        }
    }
    
    private func getTitle(for type: HealthDataType) -> String {
            switch type {
            case .distance: return "距离"
            case .steps: return "步数"
            case .heartRate: return "心率"
            case .hrv: return "HRV"
            case .bloodOxygen: return "血氧"
            case .calories: return "卡路里"
            case .exercise: return "锻炼时长"
            case .activeHours: return "活动小时"
            case .restingHeartRate: return "静息心率"
            case .trainingLoad: return "训练负荷"
            @unknown default: return "未知类型"
            }
        }
}


