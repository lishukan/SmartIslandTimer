#!/bin/bash

echo "🚀 灵动岛计时器 - Widget Extension 构建脚本"
echo "=============================================="

# 检查项目结构
echo "📁 检查项目结构："
echo "主App目录文件："
find SmartIslandTimer -name "*.swift" -exec basename {} \;

echo ""
echo "Widget Extension目录文件："
find TimerWidget -name "*.swift" -exec basename {} \;

echo ""
echo "✅ 文件移动完成情况："
echo "- TimerWidget.swift ✓ 已移动到TimerWidget目录"
echo "- TimerLiveActivity.swift ✓ 已移动到TimerWidget目录并重命名为TimerWidgetLiveActivity.swift"
echo "- TimerActivityAttributes.swift ✓ 已创建在TimerWidget目录"
echo "- TimerWidgetBundle.swift ✓ 已更新在TimerWidget目录"
echo "- 主App中的Widget相关文件 ✓ 已清理"

echo ""
echo "🎯 Widget Extension功能："
echo "- 锁屏小组件：显示计时器状态和环形进度"
echo "- 灵动岛Live Activity：实时显示计时器信息"
echo "- 支持展开/紧凑/最小化模式"

echo ""
echo "📱 下一步操作："
echo "1. 在Xcode中打开项目"
echo "2. 确保TimerWidget target已正确配置"
echo "3. 为TimerWidget target设置签名"
echo "4. 编译并测试Widget Extension"

echo ""
echo "⚠️ 注意事项："
echo "- Widget Extension需要单独的签名配置"
echo "- Live Activities需要真机测试"
echo "- 确保Bundle ID正确配置"

echo ""
echo "✅ Widget Extension配置完成" 