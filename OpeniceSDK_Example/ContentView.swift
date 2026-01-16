//
//  ContentView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2025/12/24.
//

import SwiftUI
import OpeniceSDK

struct ContentView: View {
    @Binding var isBound: Bool
    
    @State private var devices: [BleDevice] = []
    
    var body: some View {
        VStack {
            HStack {
                Button("开始扫描") { Task { await startBluetoothScan() } }
                    .buttonStyle(.bordered)
                Button("停止扫描") { OpeniceSDK.shared.stopScan()  }
                    .buttonStyle(.bordered)
            }
        
            List(devices) { device in
                HStack {
                    VStack(alignment: .leading) {
                        Text(device.name)
                            .font(.headline)
                        Text(device.mac)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(device.rssi)")
                        .foregroundColor(device.rssi > -60 ? .green : .orange)
                }.onTapGesture {
                    handleDeviceTap(device: device)
                }
            }.listStyle(.plain).frame(minHeight: 0, maxHeight: 500).task {
                await startBluetoothScan()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    
    private func handleDeviceTap(device: BleDevice) {
        Task {
            let isConnected = await OpeniceSDK.shared.connect(device.id)
        
            if isConnected {
                let isSuccess = await OpeniceSDK.shared.bindRequest(
                    device: device,
                    secretKey: "101157",
                    randomNumber: "123456"
                )
                let dict: [String : Any] = [
                    "name": device.name,
                    "mac": device.mac,
                    "deviceId": device.deviceId,
                    "secretKey": "101157",
                ]
                let myDevice = DeviceInfo(from: dict)
                DeviceStorage.shared.save(myDevice)
                
                if isSuccess {
                    await MainActor.run {
                        withAnimation {
                            self.isBound = true
                        }
                    }
                }
            }
        }
    }

    private func startBluetoothScan() async {
        for await deviceList in OpeniceSDK.shared.startScan() {
            devices = deviceList
        }
    }
}
