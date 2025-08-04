//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by lishukan on 2025/7/31.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.timerName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(formatTime(context.state.remainingTime))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .monospacedDigit()
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: progress(context.state))
                        .stroke(progressColor(context.state), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                }
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.state.timerName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(formatTime(context.state.remainingTime))
                            .font(.title2)
                            .fontWeight(.bold)
                            .monospacedDigit()
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: progress(context.state))
                            .stroke(progressColor(context.state), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                    }
                }
            } compactLeading: {
                Text(formatTime(context.state.remainingTime))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .monospacedDigit()
            } compactTrailing: {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .trim(from: 0, to: progress(context.state))
                        .stroke(progressColor(context.state), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 20, height: 20)
                        .rotationEffect(.degrees(-90))
                }
            } minimal: {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .trim(from: 0, to: progress(context.state))
                        .stroke(progressColor(context.state), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 20, height: 20)
                        .rotationEffect(.degrees(-90))
                }
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func progress(_ state: TimerActivityAttributes.ContentState) -> Double {
        guard state.totalTime > 0 else { return 0 }
        return 1 - (state.remainingTime / state.totalTime)
    }
    
    private func progressColor(_ state: TimerActivityAttributes.ContentState) -> Color {
        let progress = progress(state)
        if progress < 0.3 {
            return .green
        } else if progress < 0.7 {
            return .orange
        } else {
            return .red
        }
    }
}
