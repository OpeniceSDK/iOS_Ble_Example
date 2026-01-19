//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI
import UniformTypeIdentifiers

struct OTAView: View {
    @State private var localRoutePath: String = ""
    @State private var isImporting: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("OTA模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("选择OTA文件") {
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
                                localRoutePath = destURL.path
                                print("已选择并复制文件: \(localRoutePath)")
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
                Button("升级版本") {
                    Task {
                        let state = await OpeniceManager.shared.otaRequest(filePath: localRoutePath){ prog in
                            print("升级进度: \(Int(prog * 100))%")
                        }
                        print("升级结果: \(state)")
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
}
