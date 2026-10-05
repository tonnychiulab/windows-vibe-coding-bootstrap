# Windows Vibe Coding Bootstrap

A reproducible baseline for Windows PowerShell-based development: Git, GitHub CLI, Node.js, Python, package managers, and practical CLI tools.

Windows PowerShell 開發環境的可重複設定基線：Git、GitHub CLI、Node.js、Python、套件管理工具與常用 CLI 工具。

## Languages / 語言

- [繁體中文設定說明](documents/SETUP.zh-TW.md)
- [English setup guide](documents/SETUP.en.md)

## Scope / 範圍

This repository documents the workstation baseline prepared for vibe coding. It intentionally separates machine-wide tools from account-specific settings.

本儲存庫記錄 vibe coding 使用的 Windows 基礎環境，並刻意將機器工具與帳號專屬設定分開。

Included / 包含：

- Git and GitHub CLI / Git 與 GitHub CLI
- Node.js, npm, pnpm / Node.js、npm、pnpm
- Python and uv / Python 與 uv
- jq and terminal productivity tools / jq 與終端機效率工具
- PowerShell installation and LSP guidance / PowerShell 安裝與 LSP 指引
- Repeatable installation and verification scripts / 可重複執行的安裝與驗證腳本

Not included / 不包含：

- GitHub tokens, passwords, SSH private keys, or personal Email addresses
- Docker, Visual Studio Build Tools, or vendor-specific AI CLIs unless a project requires them
- Git identity or GitHub authentication automation

## Attribution / 來源致謝

This baseline was inspired by [nczz's “Oh My Pi (omp) Windows 安裝 SOP”](https://gist.github.com/nczz/94e62110ec183a49909c054f61ba10a4). Thanks to **nczz** for documenting the Windows/PowerShell prerequisite order, WinGet flags, PATH behavior, and common native-addon troubleshooting points.

本基線設定參考 **nczz** 的 [「Oh My Pi (omp) Windows 安裝 SOP」](https://gist.github.com/nczz/94e62110ec183a49909c054f61ba10a4)。感謝 **nczz** 整理 Windows/PowerShell 前置套件順序、WinGet 參數、PATH 行為與 native addon 常見問題。

This repository generalizes that idea into a reusable development baseline; it is not an official fork of the referenced Gist. / 本儲存庫將該想法整理成可重複使用的開發環境基線，並非該 Gist 的官方 fork。


## Quick start / 快速開始

Run from an elevated or normal PowerShell window as appropriate for your machine:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\scripts\Install-BaseTools.ps1 -IncludePowerShell7
.\scripts\Verify-Environment.ps1
```

在適合目前電腦權限的 PowerShell 視窗執行：

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\scripts\Install-BaseTools.ps1 -IncludePowerShell7
.\scripts\Verify-Environment.ps1
```

Restart PowerShell after installation so the updated PATH is loaded. / 安裝完成後請重新開啟 PowerShell，讓新的 PATH 生效。

Then configure account-specific settings manually:

接著手動設定帳號專屬內容：

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
gh auth login
```

## Repository layout / 儲存庫結構

```text
documents/
  SETUP.en.md       English setup guide
  SETUP.zh-TW.md    繁體中文設定說明
scripts/
  Install-BaseTools.ps1    Install missing baseline tools
  Verify-Environment.ps1   Verify commands and smoke checks
README.md
.gitignore
```

## Security / 安全性

Never commit credentials or command output containing tokens. `gh auth login` stores the credential through GitHub CLI's supported credential storage; this repository stores only procedures and package identifiers.

絕對不要提交憑證或含有 token 的命令輸出。`gh auth login` 會使用 GitHub CLI 支援的憑證儲存方式；本儲存庫只保存流程與套件識別碼。

## Baseline snapshot / 基線快照

The original workstation verification recorded Git, GitHub CLI, jq, Node.js, npm, Python, uv, pnpm, ripgrep, fd, fzf, delta, just, bat, and 7-Zip as available. Run `Verify-Environment.ps1` on the target machine instead of assuming those versions are current.

原始工作站驗證確認 Git、GitHub CLI、jq、Node.js、npm、Python、uv、pnpm、ripgrep、fd、fzf、delta、just、bat 與 7-Zip 可用。請在目標電腦執行 `Verify-Environment.ps1`，不要假設版本永遠相同。
