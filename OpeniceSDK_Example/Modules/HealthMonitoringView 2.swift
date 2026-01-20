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
                    Button(getTitle(for: type)) {
                        Task {
                            let now = Int(Date().timeIntervalSince1970 * 1000)
                            let list = await OpeniceManager.shared.syncHealthData(type, timestamp: now)
                            print("   结果: \(list?.count ?? 0) 条")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            
        }
    }
    
    private func getTitle(for type: HealthDataType) -> String {
            switch type {
            case .distance: return "获取距离"
            case .steps: return "获取步数"
            case .heartRate: return "获取心率"
            case .hrv: return "获取压力"
            case .bloodOxygen: return "获取血氧"
            case .calories: return "获取卡路里"
            case .exercise: return "获取锻炼时长"
            case .activeHours: return "获取活动小时"
            case .restingHeartRate: return "获取静息心率"
            case .trainingLoad: return "获取训练负荷"
            @unknown default: return "未知类型"
            }
        }
}


