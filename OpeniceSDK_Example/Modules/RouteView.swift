//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI
import CoreLocation

struct RouteView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("路线模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                
                Button("新增路线") {
                    Task {
                        
                        let points = generateSimulatedTrack(center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074), count: 50)
                        
                        let state = await OpeniceManager.shared.addRouteList(routeId: 102259, routeName:"yes1",
                                                                             routeDistance: 199,
                                                                             coordinates: points,
                        ) { prog in
                            print("上传进度: \(Int(prog * 100))%")
                        }
                        print("新增路线结果: \(state)")
                    }
                }.buttonStyle(.bordered)
                Button("获取路线列表") {
                    Task {
                        let result = await OpeniceManager.shared.getRouteList()
                        print("获取路线列表:", result as Any)
                    }
                }.buttonStyle(.bordered)
                
                Button("删除路线") {
                    Task {
                        let success = await OpeniceManager.shared.deleteRouteList(routeIds: [102259])
                        print("删除路线 success:", success)
                    }
                }.buttonStyle(.bordered)
                
            }
        }
    }
    
    // Generate a circle of points around a center
    public func generateSimulatedTrack(center: CLLocationCoordinate2D, count: Int) -> [CLLocationCoordinate2D] {
        var list: [CLLocationCoordinate2D] = []
        let radius = 0.01 // rough degrees
        
        for i in 0..<count {
            let angle = Double(i) * (2.0 * .pi / Double(count))
            let lat = center.latitude + radius * cos(angle)
            let lng = center.longitude + radius * sin(angle)
            list.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        return list
    }
}
