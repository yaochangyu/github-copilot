#Requires -Version 5.1
<#
.SYNOPSIS
    Sync .github folder to AI agent folders in user home directory
.DESCRIPTION
    Sync .github folder content to .copilot, .gemini, .claude, .github folders under user home
    Supports both Windows and WSL environments
.PARAMETER WslUser
    WSL username. Defaults to current Windows username.
.EXAMPLE
    .\sync-ai-agents.ps1
.EXAMPLE
    .\sync-ai-agents.ps1 -WslUser myuser
#>

param(
    [string]$WslUser = $env:USERNAME
)

$ErrorActionPreference = 'Stop'

$sourceDir = $PSScriptRoot  # .github folder
$userHome = $env:USERPROFILE

# Define target folders under user home directory
$targetDirs = @(
    '.copilot',
    '.gemini',
    '.claude',
    '.github'
)

# Define files and folders to sync (relative to .github)
$itemsToSync = @(
    'agents',
    'prompts',
    'skills',
    'mcp-config.json',
    'README.md'
    # Exclude copilot-instructions.md - handled by link-ai-instructions.ps1
    # Exclude link-ai-instructions.ps1 and this script
)

Write-Host "Syncing .github folder to user home AI agent folders..." -ForegroundColor Cyan
Write-Host "Source folder: $sourceDir" -ForegroundColor Gray
Write-Host "Target base: $userHome" -ForegroundColor Gray
Write-Host ""

foreach ($targetDirName in $targetDirs) {
    $targetBase = Join-Path $userHome $targetDirName
    
    # Ensure target base folder exists
    if (-not (Test-Path $targetBase)) {
        New-Item -ItemType Directory -Path $targetBase -Force | Out-Null
        Write-Host "[OK] Created folder: ~\$targetDirName" -ForegroundColor Green
    }
    
    foreach ($item in $itemsToSync) {
        $sourcePath = Join-Path $sourceDir $item
        $targetPath = Join-Path $targetBase $item
        
        if (-not (Test-Path $sourcePath)) {
            Write-Host "[WARN] Skipping non-existent item: $item" -ForegroundColor Yellow
            continue
        }
        
        # Delete existing target (might be old link or file)
        if (Test-Path $targetPath) {
            Remove-Item -Path $targetPath -Recurse -Force
        }
        
        $sourceItem = Get-Item $sourcePath
        $itemType = if ($sourceItem.PSIsContainer) { "Folder" } else { "File" }
        
        try {
            # Try to create symbolic link
            if ($sourceItem.PSIsContainer) {
                New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath -ErrorAction Stop | Out-Null
            } else {
                New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath -ErrorAction Stop | Out-Null
            }
            Write-Host "  [OK] Symbolic link: ~\$targetDirName\$item ($itemType)" -ForegroundColor Green
        }
        catch {
            # Symlink failed, use hard link (files only) or copy
            if (-not $sourceItem.PSIsContainer) {
                try {
                    # Try hard link
                    New-Item -ItemType HardLink -Path $targetPath -Target $sourcePath -ErrorAction Stop | Out-Null
                    Write-Host "  [OK] Hard link: ~\$targetDirName\$item (File)" -ForegroundColor Green
                }
                catch {
                    # Hard link failed, copy file
                    Copy-Item -Path $sourcePath -Destination $targetPath -Force
                    Write-Host "  [INFO] Copied file: ~\$targetDirName\$item (Symlink/Hardlink unavailable)" -ForegroundColor Cyan
                }
            }
            else {
                # Folder symlink failed, recursive copy
                Copy-Item -Path $sourcePath -Destination $targetPath -Recurse -Force
                Write-Host "  [INFO] Copied folder: ~\$targetDirName\$item (Symlink unavailable)" -ForegroundColor Cyan
            }
        }
    }
    
    Write-Host ""
}

# WSL sync (if on Windows)
if ($IsWindows -or (-not (Get-Variable IsWindows -ErrorAction SilentlyContinue))) {
    Write-Host "Processing WSL environment..." -ForegroundColor Cyan
    
    # Check if WSL is available
    try {
        $wslCheck = wsl.exe -l -q 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[WARN] WSL unavailable, skipping WSL sync" -ForegroundColor Yellow
            exit 0
        }
    }
    catch {
        Write-Host "[WARN] WSL unavailable, skipping WSL sync" -ForegroundColor Yellow
        exit 0
    }
    
    $wslHome = "/home/$WslUser"
    $drive = $sourceDir.Substring(0, 1).ToLower()
    $pathNoDrive = $sourceDir.Substring(2) -replace '\\','/'
    $wslSourceDir = "/mnt/$drive$pathNoDrive"
    
    $wslSourceDirEsc = $wslSourceDir -replace "'","'\\''"
    
    $commands = @('set -e')
    
    foreach ($targetDirName in $targetDirs) {
        $wslTargetBase = "$wslHome/$targetDirName"
        $wslTargetBaseEsc = $wslTargetBase -replace "'","'\\''"
        
        # Create target folder
        $commands += "mkdir -p '$wslTargetBaseEsc'"
        
        foreach ($item in $itemsToSync) {
            $wslSourcePath = "$wslSourceDir/$item"
            $wslTargetPath = "$wslTargetBase/$item"
            
            $wslSourcePathEsc = $wslSourcePath -replace "'","'\\''"
            $wslTargetPathEsc = $wslTargetPath -replace "'","'\\''"
            
            # Delete old link, create new link
            $commands += "rm -rf '$wslTargetPathEsc'"
            $commands += "ln -sf '$wslSourcePathEsc' '$wslTargetPathEsc'"
            $commands += "echo '  [OK] WSL symlink: ~/$targetDirName/$item'"
        }
    }
    
    $wslCommand = $commands -join '; '
    
    try {
        wsl.exe -d Ubuntu-24.04 -- /bin/bash -lc $wslCommand
        Write-Host ""
        Write-Host "[OK] WSL sync completed" -ForegroundColor Green
    }
    catch {
        Write-Host "[WARN] WSL sync failed: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Sync completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Tips:" -ForegroundColor Cyan
Write-Host "- Symbolic links will auto-sync .github changes" -ForegroundColor Gray
Write-Host "- If you see copy messages, symlinks are not supported in that environment" -ForegroundColor Gray
Write-Host "- Copied files need to re-run this script to update" -ForegroundColor Gray
