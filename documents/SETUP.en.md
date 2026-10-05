# Windows Vibe Coding Baseline Setup (English)

## 1. Purpose

This guide turns the baseline Windows PowerShell workstation setup into a repeatable process for Node.js, Python, GitHub, and general CLI development.

This repository stores no passwords, tokens, SSH private keys, or personal email addresses. Account authentication and Git author data must be configured by the user.

## 2. Prerequisites

- Windows 10/11
- PowerShell 5.1 with a working `winget` command
- Network access to the Microsoft Store / WinGet source
- Administrator rights may be required depending on the selected package installation scope

Check WinGet:

```powershell
winget --version
```

If `winget` is unavailable, install or update **App Installer**, then restart PowerShell.

## 3. Install the baseline tools

The script installs only commands that are currently missing. Existing tools are skipped. PowerShell 7 is optional; include `-IncludePowerShell7` to install it.

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\scripts\Install-BaseTools.ps1 -IncludePowerShell7
```

Package list:

| Tool | Command | WinGet ID | Purpose |
|---|---|---|---|
| Git | `git` | `Git.Git` | Version control |
| GitHub CLI | `gh` | `GitHub.cli` | GitHub operations and auth |
| jq | `jq` | `jqlang.jq` | JSON processing |
| Node.js | `node` | `OpenJS.NodeJS.LTS` | JavaScript runtime |
| Python | `python` | `Python.Python.3.13` | Python runtime |
| uv | `uv` | `astral-sh.uv` | Python package and project management |
| pnpm | `pnpm` | `pnpm.pnpm` | Node.js package management |
| ripgrep | `rg` | `BurntSushi.ripgrep.MSVC` | Full-text search |
| fd | `fd` | `sharkdp.fd` | File search |
| fzf | `fzf` | `junegunn.fzf` | Fuzzy search |
| delta | `delta` | `dandavison.delta` | Git diff viewer |
| bat | `bat` | `sharkdp.bat` | Syntax-highlighted file viewing |
| just | `just` | `Casey.Just` | Project task commands |
| 7-Zip | `7z` | `7zip.7zip` | Compression and extraction |
| PowerShell 7 (optional) | `pwsh` | `Microsoft.PowerShell` | Modern PowerShell runtime |

Close and reopen PowerShell after installation. To reload the persistent Machine/User PATH without opening a new window:

```powershell
$env:Path = `
  [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
  [Environment]::GetEnvironmentVariable("Path", "User")
```

## 4. Verify the tools

```powershell
.\scripts\Verify-Environment.ps1
```

The verifier checks:

- Whether all baseline commands resolve
- Whether major tool versions can be read
- `jq -n true`
- A small Python calculation
- A small Node.js calculation

## 5. Configure Git identity

This is personal account data and must not be guessed by an installation script:

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Check the values:

```powershell
git config --global --get user.name
git config --global --get user.email
```

If you do not want a global email, configure the identity only inside a repository:

```powershell
git config user.name "Your Name"
git config user.email "you@example.com"
```

## 6. Authenticate GitHub CLI

Complete browser authentication:

```powershell
gh auth login
```

Recommended choices:

1. `GitHub.com`
2. `HTTPS`
3. Browser-based login

Verify:

```powershell
gh auth status
```

Never write the output of `gh auth token` to a file, commit, or public channel.

## 7. PowerShell Editor Services (PSES) and LSP

PSES is an editor language server. It is not required by the PowerShell terminal itself.

| Scenario | Recommendation |
|---|---|
| Running PowerShell only in a terminal | No PSES required |
| VS Code | Install the Microsoft PowerShell extension; do not manually install PSES |
| Neovim, Emacs, or another LSP client | Install the PSES bundle and configure that editor's LSP client |

PSES primarily supports PowerShell 7+; Windows PowerShell 5.1 is best-effort. For a modern PowerShell development experience, include:

```powershell
.\scripts\Install-BaseTools.ps1 -IncludePowerShell7
```

## 8. Deliberately excluded tools

These are not part of the generic baseline:

- Docker: install per project requirements
- Visual Studio Build Tools: install only when native package compilation is required
- Vendor-specific AI coding CLIs: choose based on the service and account requirements
- The editor itself: do not force VS Code, Neovim, or another editor on every machine

## 9. Troubleshooting

### Command not found

Restart PowerShell. If the command is still missing:

```powershell
Get-Command <command> -ErrorAction SilentlyContinue
$env:Path -split ';'
```

### `npm.ps1` blocked by execution policy

On Windows PowerShell, use `npm.cmd`, or adjust the current-user policy if permitted:

```powershell
npm.cmd --version
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### WinGet cannot find a package

Update the sources and retry:

```powershell
winget source update
```

## 10. Verified baseline snapshot

The original workstation setup verified these commands as available:

`git`, `gh`, `jq`, `node`, `npm`, `python`, `uv`, `pnpm`, `rg`, `fd`, `fzf`, `delta`, `just`, `bat`, `7z`.

Versions change over time; use the output of `Verify-Environment.ps1` as the source of truth.
