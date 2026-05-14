# River 快捷键参照表

基于当前 `~/.config/river/init` 实际配置整理。

## 启动与程序

| 快捷键 | 动作 |
|---|---|
| `Super + Return` | 启动 `footclient` |
| `Super + Space` | 启动 `fuzzel` |

## 窗口管理

| 快捷键 | 动作 |
|---|---|
| `Super + Q` | 关闭当前窗口 |
| `Super + Shift + E` | 退出 river |
| `Super + J` | 聚焦下一个窗口 |
| `Super + K` | 聚焦上一个窗口 |
| `Super + Shift + J` | 与下一个窗口交换 |
| `Super + Shift + K` | 与上一个窗口交换 |
| `Super + Shift + Return` | 将当前窗口 zoom 到布局栈顶部 |
| `Super + T` | 切换浮动 |
| `Super + F` | 切换全屏 |

## 显示器 / 输出切换

| 快捷键 | 动作 |
|---|---|
| `Super + Period` | 聚焦下一个输出 |
| `Super + Comma` | 聚焦上一个输出 |
| `Super + Shift + Period` | 把当前窗口发送到下一个输出 |
| `Super + Shift + Comma` | 把当前窗口发送到上一个输出 |

## 布局控制（rivertile）

### 主区域比例

| 快捷键 | 动作 |
|---|---|
| `Super + H` | 主区域比例 `-0.05` |
| `Super + L` | 主区域比例 `+0.05` |

### 主区域窗口数

| 快捷键 | 动作 |
|---|---|
| `Super + Shift + H` | 主区域窗口数 `+1` |
| `Super + Shift + L` | 主区域窗口数 `-1` |

### 主区域方向

| 快捷键 | 动作 |
|---|---|
| `Super + Up` | 主区域在上 |
| `Super + Right` | 主区域在右 |
| `Super + Down` | 主区域在下 |
| `Super + Left` | 主区域在左 |

## 浮动窗口移动 / 吸附 / 缩放

### 移动窗口

| 快捷键 | 动作 |
|---|---|
| `Super + Alt + H` | 向左移动 100 |
| `Super + Alt + J` | 向下移动 100 |
| `Super + Alt + K` | 向上移动 100 |
| `Super + Alt + L` | 向右移动 100 |

### 吸附到边缘

| 快捷键 | 动作 |
|---|---|
| `Super + Alt + Control + H` | 吸附左侧 |
| `Super + Alt + Control + J` | 吸附下侧 |
| `Super + Alt + Control + K` | 吸附上侧 |
| `Super + Alt + Control + L` | 吸附右侧 |

### 调整大小

| 快捷键 | 动作 |
|---|---|
| `Super + Alt + Shift + H` | 水平缩小 100 |
| `Super + Alt + Shift + J` | 垂直增大 100 |
| `Super + Alt + Shift + K` | 垂直缩小 100 |
| `Super + Alt + Shift + L` | 水平增大 100 |

## Tag / 工作区

| 快捷键 | 动作 |
|---|---|
| `Super + 1..9` | 切换到 tag 1..9 |
| `Super + Shift + 1..9` | 将当前窗口设置到 tag 1..9 |
| `Super + Control + 1..9` | 切换显示 tag 1..9 |
| `Super + Shift + Control + 1..9` | 切换当前窗口是否带有 tag 1..9 |
| `Super + 0` | 聚焦全部 tags |
| `Super + Shift + 0` | 给当前窗口打上全部 tags |

## 模式切换

| 快捷键 | 动作 |
|---|---|
| `Super + F11` | 进入 `passthrough` 模式 |
| `passthrough` 模式下 `Super + F11` | 返回 `normal` 模式 |

## 鼠标绑定

| 快捷键 | 动作 |
|---|---|
| `Super + 左键拖动` | 移动窗口 |
| `Super + 右键拖动` | 调整窗口大小 |
| `Super + 中键` | 切换浮动 |

## 多媒体键（normal / locked 都生效）

| 按键 | 动作 |
|---|---|
| `XF86Eject` | `eject -T` |
| `XF86AudioRaiseVolume` | 音量 +5 |
| `XF86AudioLowerVolume` | 音量 -5 |
| `XF86AudioMute` | 静音切换 |
| `XF86AudioMedia` | 播放/暂停 |
| `XF86AudioPlay` | 播放/暂停 |
| `XF86AudioPrev` | 上一首 |
| `XF86AudioNext` | 下一首 |
| `XF86MonBrightnessUp` | 亮度 +5% |
| `XF86MonBrightnessDown` | 亮度 -5% |

## 额外说明

- 默认布局：`rivertile`
- `rivertile` 启动参数：`-view-padding 6 -outer-padding 6`
- 自动启动脚本：`~/.config/river/autostart.sh`

## 检查时发现的注释问题

你的 `init` 里有几处**注释和实际绑定不一致**，配置本身能用，但注释容易误导：

1. 注释写“`Super+Shift+Return` 启动 foot”，实际是 **`Super + Return` 启动 footclient**。
2. 注释写“`Super+Return` zoom”，实际是 **`Super + Shift + Return` zoom**。
3. 注释写“`Super+Space` 切换浮动”，实际是 **`Super + T` 切换浮动**；`Super + Space` 现在是启动 `fuzzel`。

建议后续把注释改成和实际绑定一致，避免自己过一阵子看晕。
