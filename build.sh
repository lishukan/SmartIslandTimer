#!/bin/bash

echo "🚀 灵动岛计时器 - 构建脚本"
echo "================================"

# 检查Xcode是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode未安装或未在PATH中"
    exit 1
fi

# 检查项目文件
if [ ! -f "SmartIslandTimer.xcodeproj/project.pbxproj" ]; then
    echo "❌ 项目文件不存在"
    exit 1
fi

echo "✅ 项目文件检查通过"

# 统计代码行数
echo "📊 代码统计："
find SmartIslandTimer -name "*.swift" | xargs wc -l | tail -1

# 检查Swift文件
echo "📁 Swift文件列表："
find SmartIslandTimer -name "*.swift" -exec basename {} \;

# 检查配置文件
echo "📋 配置文件检查："
if [ -f "SmartIslandTimer/Info.plist" ]; then
    echo "✅ Info.plist 存在"
else
    echo "❌ Info.plist 缺失"
fi

if [ -f "SmartIslandTimer/SmartIslandTimer.entitlements" ]; then
    echo "✅ Entitlements 存在"
else
    echo "❌ Entitlements 缺失"
fi

echo ""
echo "🎯 项目特性："
echo "- 3个预设计时器（煮面/番茄钟/HIIT）"
echo "- 灵动岛实时环形进度显示"
echo "- 锁屏小组件支持"
echo "- 震动提醒功能"
echo "- iOS 16+ 专用"

echo ""
echo "📱 使用说明："
echo "1. 在Xcode中打开 SmartIslandTimer.xcodeproj"
echo "2. 选择iPhone模拟器或真机"
echo "3. 运行项目"
echo "4. 选择计时器预设开始使用"

echo ""
echo "💰 盈利模式："
echo "- App Store 6元买断制"
echo "- 同赛道买断缺口明显"
echo "- 自带流量（灵动岛神器话题2.4亿播放）"

echo ""
echo "✅ 构建脚本完成" 