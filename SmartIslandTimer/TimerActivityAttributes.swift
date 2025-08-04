//
//  TimerActivityAttributes.swift
//  SmartIslandTimer
//
//  Created by lishukan on 2025/7/31.
//

import Foundation
import ActivityKit
import SwiftUI

struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var remainingTime: TimeInterval
        var totalTime: TimeInterval
        var timerName: String
        var isRunning: Bool
    }
    
    var timerName: String
    var totalTime: TimeInterval
} 