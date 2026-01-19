//
//  DeviceInfoView.swift
//  OpeniceManager_Example
//
//  Created by 易大宝 on 2026/1/8.
//

import OpeniceSDK
import SwiftUI
import UniformTypeIdentifiers

struct AGPSView: View {
    @State private var localPath: String = ""
    @State private var isImporting: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("AGPS内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("选择星历文件") {
                    isImporting = true
                }
                .buttonStyle(.bordered)
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [UTType.item],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        guard let url = urls.first else { return }
                        if url.startAccessingSecurityScopedResource() {
                            defer { url.stopAccessingSecurityScopedResource() }
                            do {
                                // 拷贝到本地可访问目录
                                let data = try Data(contentsOf: url)
                                let destURL = FileManager.default
                                    .urls(for: .documentDirectory, in: .userDomainMask)[0]
                                    .appendingPathComponent(url.lastPathComponent)
                                try data.write(to: destURL, options: .atomic)
                                localPath = destURL.path
                                print("已选择并复制文件: \(localPath)")
                            } catch {
                                print("读取/复制文件失败: \(error)")
                            }
                        } else {
                            print("无法访问安全作用域资源")
                        }
                    case .failure(let error):
                        print("选择文件失败: \(error)")
                    }
                }
                Button("更新版本") {
                    Task {
                        let nowTimestamp = Int(Date().timeIntervalSince1970)
                        let config = AgpsConfig(
                            longitude: 112.9483,
                            latitude: 28.2278,
                            timestamp: nowTimestamp,
                            
                            // 卫星状态数据
                            gpsGlonassState: 0,
                            gpsGlonassUpdateDate: nowTimestamp,
                            gpsGlonassExpiryDate: 7,
                            
                            gpsState: 1,
                            gpsUpdateDate: nowTimestamp+1,
                            gpsExpiryDate: 7,
                            
                            galileoState: 1,
                            galileoUpdateDate: nowTimestamp+1,
                            galileoExpiryDate: 7,
                            
                            glonassState: 1,
                            glonassUpdateDate: nowTimestamp+1,
                            glonassExpiryDate: 7,
                            
                            beidouState: 1,
                            beidouUpdateDate: nowTimestamp+1,
                            beidouExpiryDate: 7
                        )
                        
                        let state = await OpeniceManager.shared.installAgps(config, filePath: localPath){ prog in
                            print("AGPS传输进度: \(Int(prog * 100))%")
                        }
                        print("AGPS结果: \(state)")
                    }
                }.buttonStyle(.bordered)
                
            }
        }
    }
}
