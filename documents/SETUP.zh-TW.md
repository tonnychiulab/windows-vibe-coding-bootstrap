# Windows Vibe Coding 基礎環境設定（繁體中文）

## 1. 目的

這份文件將 Windows PowerShell 工作站的基礎工具設定整理成可重複執行的流程，供後續 Node.js、Python、GitHub 與一般 CLI 開發使用。

本專案不保存任何密碼、token、SSH 私鑰或個人 Email。帳號認證與 Git 作者資料必須由使用者自行設定。

## 2. 前置條件

- Windows 10/11
- PowerShell 5.1 可執行 `winget` 的環境
- 可連線至 Microsoft Store / WinGet source
- 安裝工具時可能需要系統管理員權限；一般使用者安裝則依 WinGet 的提示處理

確認 WinGet：

```powershell
winget --version
```

如果 `winget` 不存在，先安裝或更新 **App Installer**，再重新開啟 PowerShell。

## 3. 安裝基礎工具

腳本只會嘗試安裝目前找不到的命令；已存在的工具會略過。預設不安裝 PowerShell 7，若要一併安裝請加上 `-IncludePowerShell7`。

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\scripts\Install-BaseTools.ps1 -IncludePowerShell7
```

安裝清單：

| 工具 | 命令 | WinGet ID | 用途 |
|---|---|---|---|
| Git | `git` | `Git.Git` | 版本控制 |
| GitHub CLI | `gh` | `GitHub.cli` | GitHub 操作與認證 |
| jq | `jq` | `jqlang.jq` | JSON 處理 |
| Node.js | `node` | `OpenJS.NodeJS.LTS` | JavaScript runtime |
| Python | `python` | `Python.Python.3.13` | Python runtime |
| uv | `uv` | `astral-sh.uv` | Python 套件與專案管理 |
| pnpm | `pnpm` | `pnpm.pnpm` | Node.js 套件管理 |
| ripgrep | `rg` | `BurntSushi.ripgrep.MSVC` | 全文搜尋 |
| fd | `fd` | `sharkdp.fd` | 檔案搜尋 |
| fzf | `fzf` | `junegunn.fzf` | 模糊搜尋 |
| delta | `delta` | `dandavison.delta` | Git diff 閱讀 |
| bat | `bat` | `sharkdp.bat` | 語法高亮檔案檢視 |
| just | `just` | `Casey.Just` | 專案任務命令 |
| 7-Zip | `7z` | `7zip.7zip` | 壓縮與解壓縮 |
| PowerShell 7（選用） | `pwsh` | `Microsoft.PowerShell` | 現代 PowerShell runtime |

安裝完成後關閉並重新開啟 PowerShell。若暫時不能重開，可載入 Machine/User PATH：

```powershell
$env:Path = `
  [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
  [Environment]::GetEnvironmentVariable("Path", "User")
```

## 4. 驗證工具

```powershell
.\scripts\Verify-Environment.ps1
```

驗證內容包含：

- 全部基礎命令是否可解析
- 主要工具版本是否可讀取
- `jq -n true`
- Python 簡單運算
- Node.js 簡單運算

## 5. Git 作者設定

這是個人設定，不應由安裝腳本猜測：

```powershell
git config --global user.name "你的名稱"
git config --global user.email "你的 Email"
```

確認：

```powershell
git config --global --get user.name
git config --global --get user.email
```

如果不希望設定全域 Email，可以只在單一儲存庫設定：

```powershell
git config user.name "你的名稱"
git config user.email "你的 Email"
```

## 6. GitHub CLI 認證

使用瀏覽器完成登入：

```powershell
gh auth login
```

建議選擇：

1. `GitHub.com`
2. `HTTPS`
3. 使用瀏覽器登入

驗證：

```powershell
gh auth status
```

不要將 `gh auth token` 的輸出寫入檔案、提交或貼到公開頻道。

## 7. PowerShell Editor Services（PSES）與 LSP

PSES 是編輯器使用的 Language Server，不是 PowerShell 終端機的必要相依套件。

| 情境 | 建議 |
|---|---|
| 只在終端機執行 PowerShell | 不需要 PSES |
| VS Code | 安裝 Microsoft PowerShell extension；不要另外手動安裝 PSES |
| Neovim、Emacs 或其他 LSP client | 安裝 PSES bundle，並依該編輯器設定 LSP |

PSES 官方目前主要支援 PowerShell 7+；Windows PowerShell 5.1 僅屬 best-effort。若要使用完整的現代 PowerShell 開發體驗，建議加上：

```powershell
.\scripts\Install-BaseTools.ps1 -IncludePowerShell7
```

## 8. 刻意不包含的工具

以下工具不在通用基線內：

- Docker：依專案需求安裝
- Visual Studio Build Tools：只有需要編譯 native 套件時安裝
- 特定 AI coding CLI：依服務供應商與帳號需求決定
- 編輯器本身：避免替使用者預設 VS Code、Neovim 或其他編輯器

## 9. 故障排除

### 命令找不到

重新開啟 PowerShell；若仍找不到，執行：

```powershell
Get-Command <command> -ErrorAction SilentlyContinue
$env:Path -split ';'
```

### `npm.ps1` 被 Execution Policy 阻擋

在 Windows PowerShell 中可使用 `npm.cmd`，或依使用者政策調整目前使用者範圍：

```powershell
npm.cmd --version
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### WinGet 找不到套件

更新來源並重試：

```powershell
winget source update
```

## 10. 已驗證基線（快照）

本次工作站設定曾驗證下列命令可用：

`git`, `gh`, `jq`, `node`, `npm`, `python`, `uv`, `pnpm`, `rg`, `fd`, `fzf`, `delta`, `just`, `bat`, `7z`。

版本會隨時間變更；以 `Verify-Environment.ps1` 的實際輸出為準。

## 11. 來源致謝

本基線設定參考 **nczz** 的 [「Oh My Pi (omp) Windows 安裝 SOP」](https://gist.github.com/nczz/94e62110ec183a49909c054f61ba10a4)。感謝 **nczz** 整理 Windows/PowerShell 前置套件順序、WinGet 參數、PATH 行為與 native addon 常見問題。

本文件將相關想法延伸為通用、可重複執行的 Windows 開發環境基線，並非該 Gist 的官方 fork。
