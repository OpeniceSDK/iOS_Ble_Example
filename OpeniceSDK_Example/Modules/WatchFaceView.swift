//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI
import PhotosUI

struct WatchFaceView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var localImagePath: String = "" // 存储保存后的本地路径
    @State private var previewImage: UIImage? = nil // (可选) 用于界面预览
    
    @State private var localPath: String = ""
    @State private var isImporting: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("表盘模块内容")
                .font(.title2)
                .foregroundColor(.red)
            if let previewImage = previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(8)
            }
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("选择背景图", systemImage: "photo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .onChange(of: selectedItem) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                                  let image = UIImage(data: data),
                           let processed = image.resizedSquare(minSide: 466) {
                            previewImage = processed
                            if let jpeg = processed.jpegData(compressionQuality: 0.9) {
                                localImagePath = saveImageToDocuments(data: jpeg) ?? ""
                                print("图片已裁剪并保存至: \(localImagePath)")
                            }
                        }
                    }
                }
                Button("安装图片表盘") {
                    Task {
                        let config = DialCustomizeConfig(
                            style: .bottom,
                            timeColor: 0xFFFFFF,
                            functionColor: 0x00FF00,
                            function: .distance,
                            backgroundPath: localImagePath
                        )
                        let state = await OpeniceManager.shared.installCustomDial(config) { prog in
                            print("进度：\(Int(prog * 100))%")
                        }
                        print("最终状态：\(state)")
                    }
                }.buttonStyle(.bordered)
                
                
                Button("选择表盘文件") {
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
                Button("安装表盘文件") {
                    Task {
                        let state = await OpeniceManager.shared.installOnlineDial(id: 2, name: "666", filePath: localPath) { prog in
                            print("进度：\(Int(prog * 100))%")
                        }
                        print("最终状态：\(state)")
                    }
                }.buttonStyle(.bordered)
                Button("获取表盘列表") {
                    Task {
                        let result = await OpeniceManager.shared.getDialList()
                        print("最终状态：\(result as Any)")
                    }
                }.buttonStyle(.bordered)
                
                Button("设置/删除表盘") {
                    Task {
                        let result = await OpeniceManager.shared.operateDial(.set, dialId: 2)
                        print("最终状态：\(result as Any)")
                    }
                }.buttonStyle(.bordered)
            }
        }
    }
    
    func saveImageToDocuments(data: Data) -> String? {
        let tempDirectory = FileManager.default.temporaryDirectory
        // 给文件起个名，这里用固定名字，也可以用 UUID
        let fileURL = tempDirectory.appendingPathComponent("custom_dial_bg.jpg")
        
        do {
            try data.write(to: fileURL)
            return fileURL.path // 返回 String 类型的路径
        } catch {
            print("保存图片失败: \(error)")
            return nil
        }
    }
}

extension UIImage {
    /// 等比放大后居中裁成正方形，最小边长 minSide
    func resizedSquare(minSide: CGFloat) -> UIImage? {
        let scale = max(minSide / size.width, minSide / size.height, 1)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let scaled = UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        let x = (scaled.size.width - minSide) / 2
        let y = (scaled.size.height - minSide) / 2
        let cropRect = CGRect(x: x, y: y, width: minSide, height: minSide).applying(.init(scaleX: scaled.scale, y: scaled.scale))

        guard let cg = scaled.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cg, scale: scaled.scale, orientation: scaled.imageOrientation)
    }
}
