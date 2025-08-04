//
//  TimerActivity.swift
//  SmartIslandTimer
//
//  Created by lishukan on 2025/7/31.
//

import Foundation
import SwiftUI
import ActivityKit

class TimerActivityManager: ObservableObject {
    @Published var currentActivity: Activity<TimerActivityAttributes>?
    private var updateTimer: Timer?
    
    func startActivity(timerName: String, totalTime: TimeInterval, remainingTime: TimeInterval) {
        // 检查是否支持Live Activities
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities not enabled")
            return
        }
        
        // 结束现有活动
        endActivity()
        
        // 创建新的Live Activity
        let attributes = TimerActivityAttributes(timerName: timerName, totalTime: totalTime)
        let contentState = TimerActivityAttributes.ContentState(
            remainingTime: remainingTime,
            totalTime: totalTime,
            timerName: timerName,
            isRunning: true
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            currentActivity = activity
            print("✅ Live Activity started: \(timerName)")
            
            // 启动定时更新
            startUpdateTimer()
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }
    
    func updateActivity(remainingTime: TimeInterval, isRunning: Bool) {
        guard let activity = currentActivity else { return }
        
        let contentState = TimerActivityAttributes.ContentState(
            remainingTime: remainingTime,
            totalTime: activity.attributes.totalTime,
            timerName: activity.attributes.timerName,
            isRunning: isRunning
        )
        
        Task {
            await activity.update(using: contentState)
            print("🔄 Live Activity updated: \(formatTime(remainingTime))")
        }
    }
    
    func endActivity() {
        stopUpdateTimer()
        guard let activity = currentActivity else { return }
        
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
        currentActivity = nil
        print("✅ Live Activity ended")
    }
    
    // MARK: - 定时更新机制
    
    private func startUpdateTimer() {
        // 每秒更新一次Live Activity
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let activity = self.currentActivity else { return }
            
            // 强制同步UserDefaults，确保获取最新数据
            let userDefaults = UserDefaults(suiteName: "group.com.lilshukan.smartislandtimer")
            userDefaults?.synchronize()
            
            // 从SharedDataManager获取最新数据
            if let timerData = SharedDataManager.shared.getTimerData() {
                self.updateActivity(remainingTime: timerData.remainingTime, isRunning: timerData.isRunning)
            }
        }
        
        // 立即执行一次更新
        if let timerData = SharedDataManager.shared.getTimerData() {
            updateActivity(remainingTime: timerData.remainingTime, isRunning: timerData.isRunning)
        }
    }
    
    private func stopUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 