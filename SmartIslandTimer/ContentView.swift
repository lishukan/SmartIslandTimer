//
//  ContentView.swift
//  SmartIslandTimer
//
//  Created by lishukan on 2025/7/31.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerModel = TimerModel()
    @StateObject private var activityManager = TimerActivityManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 标题
                VStack(spacing: 8) {
                    Text("灵动岛计时器")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("抬眼即看，专注当下")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // 计时器显示
                if timerModel.totalTime > 0 {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                                .frame(width: 200, height: 200)
                            
                            Circle()
                                .trim(from: 0, to: timerModel.progress)
                                .stroke(timerModel.selectedPreset?.color ?? .blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: timerModel.progress)
                            
                            VStack(spacing: 8) {
                                Text(timerModel.selectedPreset?.name ?? "")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(timerModel.formattedTime)
                                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        // 控制按钮
                        HStack(spacing: 20) {
                            if timerModel.isRunning {
                                Button(action: {
                                    timerModel.pauseTimer()
                                    activityManager.updateActivity(remainingTime: timerModel.remainingTime, isRunning: false)
                                }) {
                                    Image(systemName: "pause.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(Color.orange)
                                        .clipShape(Circle())
                                }
                            } else if timerModel.remainingTime > 0 {
                                Button(action: {
                                    timerModel.resumeTimer()
                                    activityManager.updateActivity(remainingTime: timerModel.remainingTime, isRunning: true)
                                }) {
                                    Image(systemName: "play.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                            }
                            
                            Button(action: {
                                timerModel.stopTimer()
                                activityManager.endActivity()
                            }) {
                                Image(systemName: "stop.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                        }
                    }
                } else {
                    // 预设按钮
                    VStack(spacing: 20) {
                        Text("选择计时器")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        ForEach(TimerPreset.defaultPresets, id: \.name) { preset in
                            Button(action: {
                                timerModel.startTimer(with: preset)
                                activityManager.startActivity(
                                    timerName: preset.name,
                                    totalTime: preset.duration,
                                    remainingTime: preset.duration
                                )
                            }) {
                                HStack {
                                    Circle()
                                        .fill(preset.color)
                                        .frame(width: 12, height: 12)
                                    
                                    Text(preset.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text(formatDuration(preset.duration))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Spacer()
                
                // 底部说明
                VStack(spacing: 8) {
                    Text("支持灵动岛显示")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("iOS 16+ 专用")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onReceive(timerModel.$remainingTime) { remainingTime in
            if timerModel.isRunning && timerModel.mode == .countdown {
                activityManager.updateActivity(remainingTime: remainingTime, isRunning: true)
                
                // 调试信息：显示同步状态
                if let timerData = SharedDataManager.shared.getTimerData() {
                    let diff = abs(remainingTime - timerData.remainingTime)
                    if diff > 0.1 {
                        print("⚠️ 数据同步延迟: App内 \(remainingTime)s, App Group \(timerData.remainingTime)s, 差异 \(diff)s")
                    }
                }
            }
        }
        .onReceive(timerModel.$isRunning) { isRunning in
            if !isRunning {
                activityManager.endActivity()
            }
        }
        .onAppear {
            // App启动时验证和清理数据
            SharedDataManager.shared.validateAndCleanupData()
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)分\(seconds > 0 ? " \(seconds)秒" : "")"
        } else {
            return "\(seconds)秒"
        }
    }
}

#Preview {
    ContentView()
}
