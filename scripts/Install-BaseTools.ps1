[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$IncludePowerShell7
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'winget was not found. Install or update App Installer, then reopen PowerShell.'
}

$packages = @(
    [pscustomobject]@{ Command = 'git';    Id = 'Git.Git';                  Name = 'Git' }
    [pscustomobject]@{ Command = 'gh';     Id = 'GitHub.cli';                Name = 'GitHub CLI' }
    [pscustomobject]@{ Command = 'jq';     Id = 'jqlang.jq';                 Name = 'jq' }
    [pscustomobject]@{ Command = 'node';   Id = 'OpenJS.NodeJS.LTS';         Name = 'Node.js LTS' }
    [pscustomobject]@{ Command = 'python'; Id = 'Python.Python.3.13';        Name = 'Python 3.13' }
    [pscustomobject]@{ Command = 'uv';     Id = 'astral-sh.uv';              Name = 'uv' }
    [pscustomobject]@{ Command = 'pnpm';   Id = 'pnpm.pnpm';                 Name = 'pnpm' }
    [pscustomobject]@{ Command = 'rg';     Id = 'BurntSushi.ripgrep.MSVC';   Name = 'ripgrep' }
    [pscustomobject]@{ Command = 'fd';     Id = 'sharkdp.fd';                Name = 'fd' }
    [pscustomobject]@{ Command = 'fzf';    Id = 'junegunn.fzf';              Name = 'fzf' }
    [pscustomobject]@{ Command = 'delta';  Id = 'dandavison.delta';          Name = 'delta' }
    [pscustomobject]@{ Command = 'bat';    Id = 'sharkdp.bat';               Name = 'bat' }
    [pscustomobject]@{ Command = 'just';   Id = 'Casey.Just';                 Name = 'just' }
    [pscustomobject]@{ Command = '7z';     Id = '7zip.7zip';                  Name = '7-Zip' }
)

if ($IncludePowerShell7) {
    $packages += [pscustomobject]@{
        Command = 'pwsh'
        Id = 'Microsoft.PowerShell'
        Name = 'PowerShell 7'
    }
}

foreach ($package in $packages) {
    if (Get-Command $package.Command -ErrorAction SilentlyContinue) {
        Write-Host ("[skip] {0}: command already available" -f $package.Name)
        continue
    }

    $arguments = @(
        'install'
        '--id', $package.Id
        '--exact'
        '--source', 'winget'
        '--accept-source-agreements'
        '--accept-package-agreements'
    )

    if ($PSCmdlet.ShouldProcess($package.Name, "winget $($arguments -join ' ')")) {
        Write-Host ("[install] {0} ({1})" -f $package.Name, $package.Id)
        & winget @arguments
        if ($LASTEXITCODE -ne 0) {
            throw "winget failed for $($package.Name) with exit code $LASTEXITCODE."
        }
    }
}

Write-Host 'Installation pass complete. Restart PowerShell before verification so PATH changes are loaded.'
