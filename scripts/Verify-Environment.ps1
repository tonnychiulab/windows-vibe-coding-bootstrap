[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# Include persistent Machine/User PATH values so a fresh verification process is not required.
$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"

$commands = @(
    'git', 'gh', 'jq', 'node', 'npm.cmd', 'python', 'uv', 'pnpm',
    'rg', 'fd', 'fzf', 'delta', 'just', 'bat', '7z'
)

$missing = New-Object System.Collections.Generic.List[string]

foreach ($commandName in $commands) {
    $command = Get-Command $commandName -ErrorAction SilentlyContinue
    if (-not $command) {
        $missing.Add($commandName)
        Write-Host ("[missing] {0}" -f $commandName) -ForegroundColor Red
        continue
    }

    if ($commandName -eq '7z') {
        $version = (& $commandName i 2>$null | Select-String '7-Zip' | Select-Object -First 1).Line
    }
    else {
        $version = (& $commandName --version 2>$null | Select-Object -First 1)
    }

    Write-Host ("[ok] {0}: {1}" -f $commandName, $version)
}

if ($missing.Count -gt 0) {
    throw ("Missing commands: {0}" -f ($missing -join ', '))
}

$jqResult = & jq -n true
if ($jqResult -ne 'true') {
    throw "jq smoke check failed: $jqResult"
}

$pythonResult = & python -c 'print(2 + 2)'
if ($pythonResult -ne '4') {
    throw "Python smoke check failed: $pythonResult"
}

$nodeResult = & node -e 'console.log(2 + 2)'
if ($nodeResult -ne '4') {
    throw "Node.js smoke check failed: $nodeResult"
}

Write-Host 'SMOKE:PASS' -ForegroundColor Green
