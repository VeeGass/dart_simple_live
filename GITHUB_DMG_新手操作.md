# GitHub 一键生成 macOS DMG：新手操作说明

这套源码已经包含：

```text
.github/workflows/build_macos_dmg.yml
```

它只会在你手动点击时运行，**不需要 Apple 开发者证书、不需要填写 GitHub Secrets，也不会生成 Android 或 iOS 安装包**。

## 你需要准备

1. 一个 GitHub 账号。
2. 安装 [GitHub Desktop](https://desktop.github.com/)。
3. 下载并解压修复后的完整源码包。
4. 建议使用公开仓库；私有仓库可用的 Actions 时长取决于你的 GitHub 账户额度。

## 第一步：在 GitHub 创建自己的副本

1. 打开原项目：<https://github.com/xiaoyaocz/dart_simple_live>
2. 点击右上角 **Fork**。
3. 在 **Owner** 里选择你自己的账号。
4. 仓库名称保持 `dart_simple_live` 即可。
5. 点击 **Create fork**。

完成后，浏览器地址应该类似：

```text
https://github.com/你的用户名/dart_simple_live
```

## 第二步：用 GitHub Desktop 下载你的仓库

1. 在你刚创建的 Fork 页面点击绿色 **Code**。
2. 选择 **Open with GitHub Desktop**。
3. GitHub Desktop 打开后点击 **Clone**。
4. 记住它显示的本地文件夹位置。
5. 在 GitHub Desktop 菜单选择 **Repository → Show in Finder**，打开仓库文件夹。

## 第三步：放入修复后的源码

1. 解压我提供的“虎牙五分钟断流修复源码 ZIP”。
2. 打开解压后最里面的 `dart_simple_live` 文件夹。
3. 把该文件夹里的**所有内容**复制到 GitHub Desktop 刚打开的仓库文件夹中。
4. 出现同名文件时选择**替换**。
5. macOS Finder 默认会隐藏 `.github` 文件夹；按 **Command + Shift + .** 可以显示隐藏文件。
6. 回到 GitHub Desktop，确认左侧更改列表中能看到：

```text
.github/workflows/build_macos_dmg.yml
simple_live_app/lib/modules/live_room/live_room_controller.dart
simple_live_core/lib/src/huya_site.dart
```

如果看不到 `.github/workflows/build_macos_dmg.yml`，请把我单独提供的 `build_macos_dmg.yml` 放到：

```text
你的仓库/.github/workflows/build_macos_dmg.yml
```

## 第四步：把修改上传到 GitHub

1. 在 GitHub Desktop 左下角 **Summary** 填写：

```text
修复虎牙五分钟断流并添加 DMG 自动构建
```

2. 点击 **Commit to master**。
3. 点击上方 **Push origin**。
4. 等待上传完成。

## 第五步：在 GitHub 生成 DMG

1. 回到浏览器里的个人仓库页面并刷新。
2. 点击仓库顶部的 **Actions**。
3. 如果首次看到工作流安全提示，点击 **I understand my workflows, go ahead and enable them**。
4. 在左侧点击 **生成 macOS DMG（手动）**。
5. 点击右侧 **Run workflow**。
6. Branch 选择 `master`。
7. 再点击绿色 **Run workflow**。
8. 页面出现一条新的运行记录。黄色圆点表示正在运行，绿色对勾表示成功。
9. 点击这条运行记录。
10. 滚动到页面底部的 **Artifacts**，点击：

```text
Simple-Live-macOS-DMG-运行编号
```

GitHub 下载的是一个 ZIP。解压后可以看到：

```text
Simple-Live-macOS-1.11.4.dmg
Simple-Live-macOS-1.11.4.dmg.sha256
```

## 第六步：安装应用

1. 双击 DMG。
2. 把 **Simple Live** 拖到 **Applications**。
3. 因为没有使用付费 Apple 开发者证书，第一次不要直接双击：
   - 在“应用程序”中右键 **Simple Live**；
   - 选择 **打开**；
   - 在弹窗中再次点击 **打开**。
4. 如果仍被拦截，打开：
   - **系统设置 → 隐私与安全性**；
   - 找到被阻止的 Simple Live；
   - 点击 **仍要打开**。

## 常见问题

### Actions 页面没有“生成 macOS DMG（手动）”

检查文件是否位于这个完整路径：

```text
.github/workflows/build_macos_dmg.yml
```

文件名必须以 `.yml` 结尾，并且已经 Commit 和 Push。

### 工作流红色叉号失败

点击失败的运行记录，再点击 **编译并打包 DMG**，展开红色步骤查看日志。通常重新点击 **Re-run all jobs** 即可排除 GitHub 下载依赖时的临时网络问题。

### 为什么下载下来先是 ZIP，不是 DMG

GitHub 的 Artifacts 会自动在外面包一层 ZIP。解压这个 ZIP 后，里面就是 DMG。

### 为什么 macOS 提示“无法验证开发者”

这个工作流生成的是 ad-hoc 临时签名版本，没有使用付费 Apple Developer ID，也没有提交 Apple 公证。只在你信任自己上传的源码和构建结果时，通过“右键 → 打开”运行。

### 以后源码有修改怎么办

在 GitHub Desktop 提交并 Push 新修改，然后再次进入 **Actions → 生成 macOS DMG（手动）→ Run workflow**，就会生成新的 DMG。

