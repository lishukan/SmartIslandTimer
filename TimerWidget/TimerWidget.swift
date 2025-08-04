//
//  TimerWidget.swift
//  TimerWidget
//
//  Created by lishukan on 2025/7/31.
//

import WidgetKit
import SwiftUI

struct TimerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TimerWidget", provider: TimerWidgetProvider()) { entry in
            TimerWidgetView(entry: entry)
        }
        .configurationDisplayName("计时器")
        .description("显示当前计时器状态")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TimerWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimerWidgetEntry {
        TimerWidgetEntry(date: Date(), remainingTime: 0, totalTime: 0, timerName: "计时器", isRunning: false)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerWidgetEntry) -> Void) {
        let entry = getCurrentEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerWidgetEntry>) -> Void) {
        let entry = getCurrentEntry()
        
        // 如果计时器正在运行，每秒更新一次
        var entries: [TimerWidgetEntry] = [entry]
        
        if entry.isRunning && entry.remainingTime > 0 {
            let calendar = Calendar.current
            let now = Date()
            
            // 生成未来60秒的更新点，每秒一次
            for i in 1...60 {
                if let nextDate = calendar.date(byAdding: .second, value: i, to: now) {
                    let nextRemainingTime = max(0, entry.remainingTime - Double(i))
                    let nextEntry = TimerWidgetEntry(
                        date: nextDate,
                        remainingTime: nextRemainingTime,
                        totalTime: entry.totalTime,
                        timerName: entry.timerName,
                        isRunning: nextRemainingTime > 0
                    )
                    entries.append(nextEntry)
                }
            }
        }
        
        // 如果计时器正在运行，0.5秒后重新获取数据；否则5分钟后更新
        let nextUpdateDate = entry.isRunning ? 
            Calendar.current.date(byAdding: .second, value: 1, to: Date()) ?? Date() :
            Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    private func getCurrentEntry() -> TimerWidgetEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.lilshukan.smartislandtimer")
        
        // 强制同步UserDefaults，确保获取最新数据
        userDefaults?.synchronize()
        
        let remainingTime = userDefaults?.double(forKey: "remainingTime") ?? 0
        let totalTime = userDefaults?.double(forKey: "totalTime") ?? 0
        let timerName = userDefaults?.string(forKey: "timerName") ?? "计时器"
        let isRunning = userDefaults?.bool(forKey: "isRunning") ?? false
        
        // 验证数据有效性
        let validRemainingTime = max(0, remainingTime)
        let validTotalTime = max(0, totalTime)
        
        return TimerWidgetEntry(
            date: Date(),
            remainingTime: validRemainingTime,
            totalTime: validTotalTime,
            timerName: timerName,
            isRunning: isRunning && validRemainingTime > 0
        )
    }
}

struct TimerWidgetEntry: TimelineEntry {
    let date: Date
    let remainingTime: TimeInterval
    let totalTime: TimeInterval
    let timerName: String
    let isRunning: Bool
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1 - (remainingTime / totalTime)
    }
    
    var formattedTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerWidgetView: View {
    let entry: TimerWidgetEntry
    
    var body: some View {
        VStack(spacing: 8) {
            Text(entry.timerName)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text(entry.formattedTime)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if entry.isRunning {
                        Text("运行中")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
    }
    
    private var progressColor: Color {
        let progress = entry.progress
        if progress < 0.3 {
            return .green
        } else if progress < 0.7 {
            return .orange
        } else {
            return .red
        }
    }
}
