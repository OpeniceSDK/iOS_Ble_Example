//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct EventsView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("提醒事项模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("获取事项列表") {
                    Task {
                        let list = await OpeniceSDK.shared.getEventList() 
                        print("事项列表:", list as Any)
                    }
                }.buttonStyle(.bordered)

                Button("新增/修改事项") {
                    Task {
                        let event = EventConfig(
                            eventId: 1,
                            year: 2026,
                            month: 1,
                            day: 10,
                            hour: 9,
                            minute: 30,
                            repeatMode: .daily,
                            content: "早会提醒"
                        )
                        let success = await OpeniceSDK.shared.addUpdateEvent(event)
                        print("新增/修改事项 success:", success)
                    }
                }.buttonStyle(.bordered)

                // 3) 删除事项
                Button("删除事项") {
                    Task {
                        let success = await OpeniceSDK.shared.deleteEvent(eventId: 1)
                        print("删除事项 success:", success)
                    }
                }.buttonStyle(.bordered)

                
            }
        }
    }
}
