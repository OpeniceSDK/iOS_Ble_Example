//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI
import UniformTypeIdentifiers

struct RouteView: View {
    @State private var localRoutePath: String = ""
    @State private var isImporting: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("路线模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("选择路线文件") {
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
                
                Button("新增路线") {
                    Task {
                        let state = await OpeniceSDK.shared.addRouteList(routeId: 102226, routeName:"111www",
                                                                       routeDistance: 1400,
                                                                       filePath: localRoutePath
                        ) { prog in
                            print("上传进度: \(Int(prog * 100))%")
                        }
                        print("新增路线结果: \(state)")
                    }
                }.buttonStyle(.bordered)
                Button("获取路线列表") {
                    Task {
                        let result = await OpeniceSDK.shared.getRouteList()
                        print("获取路线列表:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("删除路线") {
                    Task {
                        let success = await OpeniceSDK.shared.deleteRouteList(routeIds: [102226])
                        print("删除路线 success:", success)
                    }
                }.buttonStyle(.bordered)
                
            }
        }
    }
}
