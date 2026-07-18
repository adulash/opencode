# OpenCode installer for Windows.
#
# Usage:
#   irm https://raw.githubusercontent.com/adulash/opencode/dev/install.ps1 | iex
#   & ./install.ps1 -Version 1.0.0-ar.1
#
# Environment overrides:
#   OPENCODE_REPO    GitHub repo to install from (default: adulash/opencode)

param(
  [string]$Version,
  [string]$Repo
)

$ErrorActionPreference = "Stop"

if (-not $Repo) {
  $Repo = if ($env:OPENCODE_REPO) { $env:OPENCODE_REPO } else { "adulash/opencode" }
}

$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "x64" }
$filename = "opencode-windows-$arch.zip"

if (-not $Version) {
  Write-Host "Fetching latest release from $Repo..."
  $latest = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
  $Version = $latest.tag_name -replace "^v", ""
}

$url = "https://github.com/$Repo/releases/download/v$Version/$filename"
$installDir = Join-Path $env:USERPROFILE ".opencode\bin"
$tmpDir = Join-Path $env:TEMP "opencode-install-$PID"

Write-Host "Downloading opencode v$Version ($arch)..."
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
try {
  $zipPath = Join-Path $tmpDir $filename
  Invoke-WebRequest -Uri $url -OutFile $zipPath

  Write-Host "Installing to $installDir..."
  New-Item -ItemType Directory -Force -Path $installDir | Out-Null
  Expand-Archive -Path $zipPath -DestinationPath $tmpDir -Force
  Copy-Item -Path (Join-Path $tmpDir "opencode.exe") -Destination $installDir -Force
}
finally {
  Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($userPath -split ";") -notcontains $installDir) {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
  $env:Path = "$env:Path;$installDir"
  Write-Host "Added $installDir to your user PATH (restart open terminals to pick it up)."
}

Write-Host ""
Write-Host "opencode v$Version installed. Run: opencode"
