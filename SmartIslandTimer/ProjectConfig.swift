//
//  ProjectConfig.swift
//  SmartIslandTimer
//
//  Created by lishukan on 2025/7/31.
//

import Foundation
import SwiftUI

struct ProjectConfig {
    static let appName = "灵动岛计时器"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    static let bundleIdentifier = "com.smartisland.timer"
    
    // 支持的iOS版本
    static let minimumiOSVersion = "16.0"
    
    // 功能配置
    struct Features {
        static let supportsLiveActivities = true
        static let supportsDynamicIsland = true
        static let supportsLockScreenWidgets = true
        static let supportsHapticFeedback = true
    }
    
    // 预设计时器配置
    struct TimerPresets {
        static let noodleTimer = TimerPreset(name: "煮面", duration: 3 * 60, color: .orange)
        static let pomodoroTimer = TimerPreset(name: "番茄钟", duration: 25 * 60, color: .red)
        static let hiitTimer = TimerPreset(name: "HIIT", duration: 45, color: .green)
    }
    
    // 应用信息
    struct AppInfo {
        static let description = "把煮面倒计时、番茄钟、健身间歇直接塞进灵动岛 & 锁屏，抬眼即看。"
        static let keywords = ["计时器", "灵动岛", "倒计时", "番茄钟", "HIIT"]
        static let category = "Productivity"
        static let price = "¥6.00"
    }
} 