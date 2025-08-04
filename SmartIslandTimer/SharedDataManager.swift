//
//  SharedDataManager.swift
//  SmartIslandTimer
//
//  Created by lishukan on 2025/7/31.
//

import Foundation
import WidgetKit

class SharedDataManager {
    static let shared = SharedDataManager()
    private let userDefaults: UserDefaults?
    private let appGroupId = "group.com.lilshukan.smartislandtimer"
    
    private init() {
        userDefaults = UserDefaults(suiteName: appGroupId)
    }
    
    // MARK: - 写入数据
    func saveTimerData(remainingTime: TimeInterval, totalTime: TimeInterval, timerName: String, isRunning: Bool) {
        userDefaults?.set(remainingTime, forKey: "remainingTime")
        userDefaults?.set(totalTime, forKey: "totalTime")
        userDefaults?.set(timerName, forKey: "timerName")
        userDefaults?.set(isRunning, forKey: "isRunning")
        userDefaults?.set(Date(), forKey: "lastUpdate")
        userDefaults?.synchronize()
        
        // 立即刷新Widget，确保数据同步
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        print("📱 数据已同步到App Group: \(timerName) - \(remainingTime)s (运行中: \(isRunning))")
    }
    
    func clearTimerData() {
        userDefaults?.removeObject(forKey: "remainingTime")
        userDefaults?.removeObject(forKey: "totalTime")
        userDefaults?.removeObject(forKey: "timerName")
        userDefaults?.removeObject(forKey: "isRunning")
        userDefaults?.removeObject(forKey: "lastUpdate")
        userDefaults?.synchronize()
        
        // 刷新Widget
        WidgetCenter.shared.reloadAllTimelines()
        
        print("📱 计时器数据已清除")
    }
    
    // MARK: - 读取数据
    func getTimerData() -> (remainingTime: TimeInterval, totalTime: TimeInterval, timerName: String, isRunning: Bool)? {
        guard let remainingTime = userDefaults?.object(forKey: "remainingTime") as? TimeInterval,
              let totalTime = userDefaults?.object(forKey: "totalTime") as? TimeInterval,
              let timerName = userDefaults?.string(forKey: "timerName"),
              let isRunning = userDefaults?.object(forKey: "isRunning") as? Bool else {
            return nil
        }
        
        // 验证数据有效性
        guard remainingTime >= 0 && totalTime > 0 && !timerName.isEmpty else {
            print("⚠️ 无效的计时器数据，清除中...")
            clearTimerData()
            return nil
        }
        
        return (remainingTime, totalTime, timerName, isRunning)
    }
    
    func hasActiveTimer() -> Bool {
        return userDefaults?.object(forKey: "remainingTime") != nil
    }
    
    // MARK: - 数据验证
    func validateAndCleanupData() {
        guard let timerData = getTimerData() else { return }
        
        // 如果计时器应该运行但剩余时间为0，清除数据
        if timerData.isRunning && timerData.remainingTime <= 0 {
            print("🧹 清理已完成的计时器数据")
            clearTimerData()
        }
        
        // 如果最后更新时间超过1小时，清除数据
        if let lastUpdate = userDefaults?.object(forKey: "lastUpdate") as? Date {
            let timeSinceLastUpdate = Date().timeIntervalSince(lastUpdate)
            if timeSinceLastUpdate > 3600 { // 1小时
                print("🧹 清理过期的计时器数据")
                clearTimerData()
            }
        }
    }
} 