//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by lishukan on 2025/7/31.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        TimerWidgetLiveActivity()
    }
}
