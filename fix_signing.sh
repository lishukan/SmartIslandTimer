#!/bin/bash

echo "🔧 修复签名配置脚本"
echo "===================="

# 检查Xcode项目
if [ ! -f "SmartIslandTimer.xcodeproj/project.pbxproj" ]; then
    echo "❌ 项目文件不存在"
    exit 1
fi

echo "✅ 项目文件存在"

# 备份原始项目文件
cp SmartIslandTimer.xcodeproj/project.pbxproj SmartIslandTimer.xcodeproj/project.pbxproj.backup

echo "📋 当前签名配置："
echo "- 主App Bundle ID: lilshukan.SmartIslandTimer"
echo "- Widget Extension Bundle ID: lilshukan.SmartIslandTimer.TimerWidget"
echo "- 开发团队: 需要配置"

echo ""
echo "🔧 修复建议："
echo "1. 在Xcode中打开项目"
echo "2. 选择主App target (SmartIslandTimer)"
echo "3. 进入 'Signing & Capabilities'"
echo "4. 勾选 'Automatically manage signing'"
echo "5. 选择你的Apple ID作为Team"
echo "6. 对Widget Extension target重复相同操作"

echo ""
echo "⚠️ 重要提示："
echo "- 如果没有真机设备，可以先用模拟器测试"
echo "- Widget Extension在模拟器中功能有限"
echo "- Live Activities需要真机测试"

echo ""
echo "📱 模拟器测试命令："
echo "xcodebuild -scheme SmartIslandTimer -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' clean build"

echo ""
echo "✅ 脚本完成" 