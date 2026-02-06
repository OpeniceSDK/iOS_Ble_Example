//
//  DeviceInfoView.swift
//  OpeniceSDK_Example
//
//  Created by 易大宝 on 2026/1/8.
//
import OpeniceSDK
import SwiftUI

struct WeatherView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 6)
    ]
    var body: some View {
        VStack {
            Text("天气模块内容")
                .font(.title2)
                .foregroundColor(.red)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                Button("下发天气数据") {
                    Task {
                        // 1. 模拟 24 小时天气
                        var hourlyList: [HourlyWeather] = []
                        for i in 0..<24 {
                            // 简单模拟：温度在 20-28 度之间浮动
                            let temp = 20 + (i % 8)
                            // 简单模拟：天气状态随机切换
                            let state: WeatherInfo.WeatherState = (i % 3 == 0) ? .cloudy : .sunny
                            
                            let item = HourlyWeather(
                                weatherState: state,
                                temperature: temp
                            )
                            hourlyList.append(item)
                        }
                        
                        // 2. 模拟未来 7 天天气
                        var dailyList: [DailyWeather] = []
                        for i in 0..<7 {
                            let item = DailyWeather(
                                weatherState: (i % 2 == 0) ? .rain : .cloudy, // 隔天下一场雨
                                maxTemp: 30 - i, // 温度逐渐下降
                                minTemp: 22 - i,
                                sunriseHour: 6,
                                sunriseMin: 30,
                                sunsetHour: 18,
                                sunsetMin: 45,
                                moonriseHour: 19,
                                moonriseMin: 15,
                                moonsetHour: 5,
                                moonsetMin: 20
                            )
                            dailyList.append(item)
                        }
                        
                        // 3. 构造整体天气对象
                        let config = WeatherInfo(
                            city: "深圳市",
                            currentTemp: 28,
                            weatherState: .shower,      // 今天多云
                            windDirection: .southEast,  // 东南风
                            windLevel: 3,               // 3级
                            uvRays: .moderate,          // 紫外线中等
                            hourlyForecast: hourlyList,
                            dailyForecast: dailyList
                        )
                        let result =  await OpeniceManager.shared.syncWeather(config)
                        print("天气数据 result:", result as Any)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
