//
//  DeviceStorage.swift
//  
//
//  Created by 易大宝 on 2026/1/4.
//

import OpeniceSDK
import Foundation

public class DeviceStorage {
    public static let shared = DeviceStorage()
    private let key = "kCurrentBoundDevice"
        
   private init() {}
    
    // 保存设备
    func save(_ device: DeviceInfo) {
        if let data = try? JSONEncoder().encode(device) {
            UserDefaults.standard.set(data, forKey: key)
            print("💾 设备信息已保存到本地")
        }
    }
    
    // 读取设备
    public func load() -> DeviceInfo? {
        if let data = UserDefaults.standard.data(forKey: key),
           let device = try? JSONDecoder().decode(DeviceInfo.self, from: data) {
            return device
        }
        return nil
    }
    
    // 清除设备 (解绑时用)
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
