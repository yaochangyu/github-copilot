#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$root = $env:USERPROFILE
$source = Join-Path $PSScriptRoot 'copilot-instructions.md'

$targets = @(
    (Join-Path $root '.github\copilot-instructions.md')
    (Join-Path $root '.copilot\copilot-instructions.md')
    (Join-Path $root '.claude\CLAUDE.md')
    (Join-Path $root '.gemini\GEMINI.md')
)

foreach ($target in $targets) {
    $dir = Split-Path $target -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

foreach ($target in $targets) {
    if (Test-Path $target) {
        Remove-Item -Path $target -Force
    }
    $targetDrive = (Split-Path -Qualifier $target)
    $sourceDrive = (Split-Path -Qualifier $source)
    if ($targetDrive -and $sourceDrive -and $targetDrive.ToLower() -eq $sourceDrive.ToLower()) {
        New-Item -ItemType HardLink -Path $target -Target $source | Out-Null
    } else {
        try {
            New-Item -ItemType SymbolicLink -Path $target -Target $source -ErrorAction Stop | Out-Null
        } catch {
            Copy-Item -Path $source -Destination $target -Force
            Write-Host "SymbolicLink unavailable; copied file instead: $target"
        }
    }
}

Write-Host "Windows links created from: $source"

$wslHome = '/home/yao'
$drive = $source.Substring(0, 1).ToLower()
$pathNoDrive = $source.Substring(2) -replace '\\','/'
$wslSourceFromWindows = "/mnt/$drive$pathNoDrive"
$wslHomeEsc = $wslHome -replace "'","'\\''"
$wslSourceFromWindowsEsc = $wslSourceFromWindows -replace "'","'\\''"

$wslTargets = @(
    "$wslHome/.github/copilot-instructions.md",
    "$wslHome/.copilot/copilot-instructions.md",
    "$wslHome/.claude/CLAUDE.md",
    "$wslHome/.gemini/GEMINI.md"
)

$wslDirCommands = $wslTargets | ForEach-Object {
    $dir = (Split-Path $_ -Parent) -replace '\\','/'
    $dirEsc = $dir -replace "'","'\\''"
    "mkdir -p '$dirEsc'"
}
$wslLinkCommands = $wslTargets | ForEach-Object {
    $targetEsc = $_ -replace "'","'\\''"
    "rm -f '$targetEsc'; ln -sf '$wslSourceFromWindowsEsc' '$targetEsc'"
}

$wslCommandParts = @(
    'set -e'
) + $wslDirCommands + $wslLinkCommands

$wslCommand = $wslCommandParts -join '; '

wsl.exe -d Ubuntu-24.04 -- /bin/bash -lc $wslCommand

Write-Host "WSL links created from: $wslSourceFromWindows"