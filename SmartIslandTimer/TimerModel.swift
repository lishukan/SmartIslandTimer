//
//  TimerModel.swift
//  SmartIslandTimer
//
//  Created by lishukan on 2025/7/31.
//

import Foundation
import SwiftUI

struct TimerPreset: Codable, Identifiable {
    let id = UUID()
    let name: String
    let duration: TimeInterval
    let color: Color
    
    // 用于编码解码Color
    enum CodingKeys: String, CodingKey {
        case name, duration, colorHex
    }
    
    init(name: String, duration: TimeInterval, color: Color) {
        self.name = name
        self.duration = duration
        self.color = color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        let colorHex = try container.decode(String.self, forKey: .colorHex)
        color = Color(hex: colorHex) ?? .blue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(duration, forKey: .duration)
        try container.encode(color.toHex(), forKey: .colorHex)
    }
    
    static let defaultPresets: [TimerPreset] = [
        TimerPreset(name: "煮面", duration: 3 * 60, color: .orange),
        TimerPreset(name: "番茄钟", duration: 25 * 60, color: .red),
        TimerPreset(name: "HIIT", duration: 45, color: .green)
    ]
}

// 秒表模式
enum TimerMode {
    case countdown
    case stopwatch
}

class TimerModel: ObservableObject {
    @Published var isRunning = false
    @Published var remainingTime: TimeInterval = 0
    @Published var totalTime: TimeInterval = 0
    @Published var selectedPreset: TimerPreset?
    @Published var mode: TimerMode = .countdown
    @Published var stopwatchTime: TimeInterval = 0
    @Published var customPresets: [TimerPreset] = []
    
    private var timer: Timer?
    private let userDefaults = UserDefaults.standard
    private let customPresetsKey = "CustomTimerPresets"
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1 - (remainingTime / totalTime)
    }
    
    var formattedTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedStopwatchTime: String {
        let minutes = Int(stopwatchTime) / 60
        let seconds = Int(stopwatchTime) % 60
        let centiseconds = Int((stopwatchTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
    }
    
    init() {
        loadCustomPresets()
        restoreTimerState()
    }
    
    // MARK: - 状态恢复
    
    private func restoreTimerState() {
        guard let timerData = SharedDataManager.shared.getTimerData() else { return }
        
        // 恢复计时器状态
        remainingTime = timerData.remainingTime
        totalTime = timerData.totalTime
        
        // 尝试恢复预设信息
        if let preset = TimerPreset.defaultPresets.first(where: { $0.name == timerData.timerName }) {
            selectedPreset = preset
        }
        
        // 如果计时器正在运行，重新启动
        if timerData.isRunning && remainingTime > 0 {
            isRunning = true
            startTimer()
            print("🔄 恢复计时器状态: \(timerData.timerName) - \(remainingTime)s")
        } else if remainingTime > 0 {
            // 如果计时器暂停了，显示暂停状态
            print("⏸️ 恢复暂停的计时器: \(timerData.timerName) - \(remainingTime)s")
        }
    }
    
    // MARK: - 自定义定时项管理
    
    func addCustomPreset(name: String, duration: TimeInterval, color: Color) {
        let newPreset = TimerPreset(name: name, duration: duration, color: color)
        customPresets.append(newPreset)
        saveCustomPresets()
    }
    
    func deleteCustomPreset(at indexSet: IndexSet) {
        customPresets.remove(atOffsets: indexSet)
        saveCustomPresets()
    }
    
    private func saveCustomPresets() {
        // 简化保存逻辑，暂时不保存颜色
        let presetData = customPresets.map { ["name": $0.name, "duration": $0.duration] }
        userDefaults.set(presetData, forKey: customPresetsKey)
    }
    
    private func loadCustomPresets() {
        if let presetData = userDefaults.array(forKey: customPresetsKey) as? [[String: Any]] {
            customPresets = presetData.compactMap { data in
                guard let name = data["name"] as? String,
                      let duration = data["duration"] as? TimeInterval else { return nil }
                return TimerPreset(name: name, duration: duration, color: .blue)
            }
        }
    }
    
    // MARK: - 秒表功能
    
    func startStopwatch() {
        mode = .stopwatch
        stopwatchTime = 0
        isRunning = true
        startStopwatchTimer()
    }
    
    func pauseStopwatch() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resumeStopwatch() {
        isRunning = true
        startStopwatchTimer()
    }
    
    func stopStopwatch() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        stopwatchTime = 0
        mode = .countdown
    }
    
    private func startStopwatchTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.stopwatchTime += 0.01
        }
    }
    
    // MARK: - 倒计时功能
    
    func startTimer(with preset: TimerPreset) {
        mode = .countdown
        selectedPreset = preset
        totalTime = preset.duration
        remainingTime = preset.duration
        isRunning = true
        
        // 同步数据到App Group
        SharedDataManager.shared.saveTimerData(
            remainingTime: remainingTime,
            totalTime: totalTime,
            timerName: preset.name,
            isRunning: isRunning
        )
        
        startTimer()
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        
        // 同步数据到App Group
        SharedDataManager.shared.saveTimerData(
            remainingTime: remainingTime,
            totalTime: totalTime,
            timerName: selectedPreset?.name ?? "",
            isRunning: isRunning
        )
    }
    
    func resumeTimer() {
        isRunning = true
        
        // 同步数据到App Group
        SharedDataManager.shared.saveTimerData(
            remainingTime: remainingTime,
            totalTime: totalTime,
            timerName: selectedPreset?.name ?? "",
            isRunning: isRunning
        )
        
        startTimer()
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        remainingTime = 0
        totalTime = 0
        selectedPreset = nil
        mode = .countdown
        
        // 清除App Group数据
        SharedDataManager.shared.clearTimerData()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                
                // 立即同步数据到App Group，确保Widget能及时获取
                SharedDataManager.shared.saveTimerData(
                    remainingTime: self.remainingTime,
                    totalTime: self.totalTime,
                    timerName: self.selectedPreset?.name ?? "",
                    isRunning: self.isRunning
                )
                
                if self.remainingTime == 0 {
                    self.timerCompleted()
                }
            }
        }
        
        // 立即同步初始数据
        SharedDataManager.shared.saveTimerData(
            remainingTime: remainingTime,
            totalTime: totalTime,
            timerName: selectedPreset?.name ?? "",
            isRunning: isRunning
        )
    }
    
    private func timerCompleted() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        
        // 震动提醒
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        // 清除App Group数据
        SharedDataManager.shared.clearTimerData()
        
        print("⏰ 计时器完成！")
    }
}

// MARK: - Color扩展
extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "#%06x", rgb)
    }
    
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 