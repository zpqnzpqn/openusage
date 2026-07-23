# OpenUsage (繁體中文版)

在 macOS 選單列輕鬆追蹤您的 AI 程式設計訂閱用量 — 原生 Swift 打造。

OpenUsage 能在單一彈出視窗（Popover）中完整顯示您的 AI 程式設計方案使用量：包含 Session 與每週上限、點數餘額以及花費金額。您還可以將最重要的指標直接釘選至 macOS 選單列。

<p align="center">
  <img src="assets/screenshot.jpg?v=20260706" alt="OpenUsage 選單列追蹤工具介面，顯示 Claude 與 Codex 的 Session、週上限及花費" width="900">
</p>

## 📥 安裝方式

**使用 Homebrew：**

```sh
brew install --cask openusage
```

**直接下載：** 進入 [Releases 頁面](https://github.com/zpqnzpqn/openusage/releases) 下載最新的 Universal DMG 檔案，開啟後將 OpenUsage 拖移至您的「應用程式」資料夾即可。

兩種安裝方式皆支援透過已簽署且公證的 [Sparkle](docs/updates.md) 進行自動更新。需要 macOS 15 (Sequoia) 或更新版本。

## 🤖 支援的 AI 提供者 (Providers)

- **[Antigravity](docs/providers/antigravity.md)** — 共享 Gemini 與 Claude 配額池、5小時及每週時間視窗
- **[Claude](docs/providers/claude.md)** — Session、每週與特定模型上限、額外用量、本地每日花費
- **[Codex](docs/providers/codex.md)** — Session、每週、點數、本地每日花費
- **[Copilot](docs/providers/copilot.md)** — AI 點數、額外用量、組織帳務、聊天與程式碼補全
- **[Cursor](docs/providers/cursor.md)** — 點數、總用量/自動/API 用量、請求數、隨需用量、每日花費
- **[Devin](docs/providers/devin.md)** — 每週與每日配額、額外用量餘額
- **[Grok](docs/providers/grok.md)** — 每週共享池、按量計費、本地每日花費
- **[OpenCode](docs/providers/opencode.md)** — Go Session/週/月上限、Zen 花費、本地每日花費
- **[OpenRouter](docs/providers/openrouter.md)** — 點數餘額、日/週/月花費 (API 金鑰)
- **[Z.ai](docs/providers/zai.md)** — Session、每週、網頁搜尋配額 (GLM Coding Plan，API 金鑰)

多數提供者會自動讀取您電腦中已存在的憑證（Keychain、認證檔案、應用程式狀態），無需重新登入。OpenRouter 與 Z.ai 是例外：因為無本地憑證可重用，需手動設定 API 金鑰（請參考 [OpenRouter 設定說明](docs/providers/openrouter.md) 或 [Z.ai 設定說明](docs/providers/zai.md)）。所有憑證僅用於發起對應提供者的請求。詳細隱私說明請參閱 [隱私權與用量資料](docs/privacy.md)。

## ✨ 主要功能

- **選單列釘選 (Menu bar pins)：** 將特定指標釘選至選單列（每個提供者最多 2 個）；可渲染為精簡文字或迷你進度條。若指標無資料會自動隱藏。
- **儀表板視窗 (Dashboard popover)：** 依提供者分組的計量器，顯示即時倒數與進度指標。點擊數值可切換顯示格式；右鍵點擊行可隱藏/加星號、單獨重新整理或開啟自訂介面。
- **全域快捷鍵：** 在任何地方快速開啟彈出視窗 — 可於偏好設定中自訂組合鍵。
- **自訂介面 (Customize)：** 開啟或關閉提供者與指標，設定常駐顯示（Always Visible）或隨需顯示（On Demand），並支援拖曳排序。
- **Stale-while-revalidate 快取：** 啟動時立即顯示快取的舊數值，背景每 5 分鐘自動更新一次。
- **[單次 CLI 工具](docs/cli.md)：** AI Agent 或命令列工具可透過 `openusage` 命令直接讀取快取的限制資料 JSON（亦可用 `openusage --force` 強制更新），無需維持選單列 App 執行。
- **[本地 HTTP API](docs/local-http-api.md)：** 其他應用程式可透過 `127.0.0.1:6736/v1/limits` 讀取資料。此 API 僅限本機存取且絕不洩漏憑證。
- **[代理伺服器支援 (Proxy)](docs/proxy.md)：** 可透過 `~/.openusage/config.json` 設定 SOCKS5 或 HTTP(S) 代理。
- **原生偏好設定：** 包含開機自動啟動、全域快捷鍵、圖示樣式、主題模式、顯示密度、12/24小時制等設定。
- **[自動更新](docs/updates.md)：** 透過 Sparkle 提供已簽署與公證的應用程式內自動更新。

## 🛠️ 建置與開發

```sh
swift build            # 編譯 Debug 版本
swift test             # 執行測試套件
./script/build_and_run.sh   # 編譯並從 dist/ 啟動開發版 App
```

## 💻 系統需求與架構

- **系統需求：** macOS 15 (Sequoia) 或更新版本
- **通用二進位檔 (Universal binary)：** 原生支援 Apple Silicon (M系列) 與 Intel 處理器的 Mac
- **架構技術：** SwiftPM 套件、SwiftUI 介面託管於 AppKit `NSStatusItem` + 自訂 `NSPanel`，全面採用 Swift 6 嚴格並發（Strict Concurrency）。

## 📜 授權條款

[MIT License](LICENSE)
