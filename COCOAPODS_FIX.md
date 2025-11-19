# CocoaPods 配置修复指南

## 问题描述
如果遇到 "CocoaPods not installed" 错误，请按照以下步骤解决。

## 验证 CocoaPods 安装

在终端运行以下命令验证 CocoaPods 是否已安装：

```bash
pod --version
```

如果显示版本号（如 `1.16.2`），说明已安装。

## 解决方案

### 方案 1: 确保 PATH 包含 CocoaPods 路径

CocoaPods 通常安装在 `/opt/homebrew/bin/pod`（Apple Silicon Mac）或 `/usr/local/bin/pod`（Intel Mac）。

将以下内容添加到 `~/.zshrc` 文件：

```bash
# Homebrew path (for Apple Silicon Mac)
export PATH="/opt/homebrew/bin:$PATH"

# 或者对于 Intel Mac
# export PATH="/usr/local/bin:$PATH"
```

然后重新加载配置：

```bash
source ~/.zshrc
```

### 方案 2: 手动运行 pod install

在项目目录中运行：

```bash
cd ios
pod install
cd ..
```

### 方案 3: 清理并重新安装

```bash
# 清理 Flutter 构建缓存
flutter clean

# 重新获取依赖
flutter pub get

# 进入 iOS 目录安装 pods
cd ios
pod install
cd ..
```

### 方案 4: 如果使用 IDE（VS Code/Android Studio）

确保 IDE 使用的终端环境变量包含 CocoaPods 路径：

#### VS Code
1. **重启 VS Code**：完全关闭并重新打开 VS Code
2. **重新加载窗口**：按 `Cmd+Shift+P`，输入 "Reload Window"
3. **检查终端 PATH**：在 VS Code 终端中运行 `echo $PATH`，确保包含 `/opt/homebrew/bin`
4. **设置 launch.json**（可选）：在 `.vscode/launch.json` 中添加环境变量：
   ```json
   {
     "env": {
       "PATH": "/opt/homebrew/bin:${env:PATH}"
     }
   }
   ```

#### Android Studio / IntelliJ IDEA
1. **重启 IDE**：完全关闭并重新打开
2. **检查 Terminal 设置**：
   - Preferences > Tools > Terminal
   - 确保 Shell path 设置为 `/bin/zsh`（不是 `/bin/bash`）
3. **设置环境变量**：
   - Preferences > Build, Execution, Deployment > Build Tools > Flutter
   - 在 Additional arguments 中添加：`--dart-define=PATH=/opt/homebrew/bin:$PATH`

#### Cursor / Windsurf
1. **重启编辑器**：完全关闭并重新打开
2. **检查终端**：在集成终端中运行 `echo $PATH`
3. **如果 PATH 不正确**，在终端中运行：
   ```bash
   export PATH="/opt/homebrew/bin:$PATH"
   ```

## 验证修复

运行以下命令验证：

```bash
flutter doctor -v
```

应该看到：
```
• CocoaPods version 1.16.2
```

## 当前状态

✅ CocoaPods 已安装（版本 1.16.2）
✅ Pods 依赖已安装（10 个 pods）
✅ Flutter 可以检测到 CocoaPods
✅ PATH 已更新（Homebrew 路径已添加到 ~/.zshrc）

## 快速修复命令

如果遇到错误，运行以下命令：

```bash
# 1. 确保 PATH 包含 Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# 2. 验证 CocoaPods 可用
pod --version

# 3. 重新安装 pods
cd ios && pod install && cd ..

# 4. 清理并重新构建
flutter clean && flutter pub get && flutter build ios --no-codesign
```

## 如果仍然遇到问题

1. **检查 IDE 的环境变量**：
   - 在 IDE 的集成终端中运行 `echo $PATH`
   - 确保包含 `/opt/homebrew/bin`

2. **重启 IDE**：
   - 完全关闭 IDE（不是只关闭窗口）
   - 重新打开 IDE

3. **使用终端构建**：
   ```bash
   cd /Users/lizhi/project/flutter/ai_test/WaterMarkly/water_markly
   export PATH="/opt/homebrew/bin:$PATH"
   flutter run
   ```

4. **检查 Flutter 配置**：
   ```bash
   flutter doctor -v
   ```
   应该看到 `CocoaPods version 1.16.2`

