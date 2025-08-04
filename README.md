# 灵动岛计时器

一个专为iPhone灵动岛设计的计时器应用，让计时器信息直接显示在灵动岛和锁屏上。

## 功能特点

### 🎯 核心功能
- **3个预设计时器**：煮面（3分钟）、番茄钟（25分钟）、HIIT（45秒）
- **灵动岛实时显示**：环形进度条 + 剩余时间
- **锁屏小组件**：同显计时器状态
- **震动提醒**：计时结束自动震动

### 🎨 界面设计
- 简洁现代的UI设计
- 流畅的动画效果
- 直观的操作体验
- 支持暂停/继续/停止

### 📱 技术特性
- iOS 16+ 专用
- SwiftUI + ActivityKit
- 无需服务器，0后端成本
- 代码不到500行

## 使用方法

1. **选择计时器**：点击预设按钮（煮面/番茄钟/HIIT）
2. **开始计时**：计时器自动在灵动岛显示
3. **控制操作**：暂停、继续、停止
4. **查看进度**：灵动岛实时显示环形进度

## 技术架构

### 主要文件
- `TimerModel.swift` - 计时器数据模型
- `TimerActivity.swift` - 灵动岛Activity管理
- `TimerLiveActivity.swift` - 灵动岛显示视图
- `TimerWidget.swift` - 锁屏小组件
- `ContentView.swift` - 主界面

### 核心组件
- **TimerModel**: 管理计时器状态和逻辑
- **TimerActivityManager**: 控制灵动岛Activity
- **TimerLiveActivity**: 灵动岛UI组件
- **TimerWidget**: 锁屏小组件

## 开发环境

- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+
- SwiftUI + ActivityKit

## 安装运行

1. 克隆项目到本地
2. 在Xcode中打开 `SmartIslandTimer.xcodeproj`
3. 选择iPhone模拟器或真机
4. 运行项目

## 注意事项

- 需要iOS 16+设备支持灵动岛
- 首次使用需要授权Live Activities权限
- 建议在真机上测试灵动岛功能

## 盈利模式

- App Store 6元买断制
- 同赛道目前全是订阅制，买断缺口明显
- 小红书/抖音"灵动岛神器"话题播放2.4亿次，自带流量

## 版本历史

- v1.0.0 - 初始版本，支持基础计时器功能 