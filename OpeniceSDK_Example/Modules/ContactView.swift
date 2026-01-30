//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct ContactView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("联系人模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("同步联系人") {
                    Task{
                        let contacts: [ContactItem] = [
                            ContactItem(name: "张三", phone: "13800000001"),
                            ContactItem(name: "李四", phone: "13800000002")
                        ]
                        let result = await OpeniceManager.shared.syncContact(contacts)
                        print("同步联系人 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
                Button("同步紧急联系人") {
                    Task{
                        let contacts: [ContactItem] = [
                            ContactItem(name: "王五", phone: "13911112222"),
                            ContactItem(name: "赵六", phone: "13933334444")
                        ]
                        let result = await OpeniceManager.shared.syncSOS(contacts)
                        print("同步紧急联系人 result:", result as Any)
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
