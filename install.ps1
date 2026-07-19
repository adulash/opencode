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

$prevErrorActionPreference = $ErrorActionPreference
$prevProgressPreference = $ProgressPreference
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

try {
  if (-not $Repo) {
    $Repo = if ($env:OPENCODE_REPO) { $env:OPENCODE_REPO } else { "adulash/opencode" }
  }

  # Constrained language mode (AppLocker/WDAC) blocks Add-Type; degrade to the
  # default AVX2 build and skip the PATH-change broadcast instead of failing.
  $nativeLoaded = $false
  try {
    Add-Type -Namespace OpenCodeInstall -Name Native -MemberDefinition @'
[DllImport("kernel32.dll")]
public static extern bool IsProcessorFeaturePresent(int feature);
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, UIntPtr wParam, string lParam, int fuFlags, int uTimeout, out UIntPtr lpdwResult);
'@
    $nativeLoaded = $true
  }
  catch {
    $nativeLoaded = $false
  }

  # Machine architecture, not process architecture: an emulated x64/x86 shell on
  # Windows-on-ARM reports AMD64/x86 in PROCESSOR_ARCHITECTURE. The registry
  # value is never redirected; PROCESSOR_ARCHITEW6432 covers WOW64 shells if the
  # registry read comes back empty.
  $machineArch = [Microsoft.Win32.Registry]::GetValue(
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment",
    "PROCESSOR_ARCHITECTURE",
    $null)
  if (-not $machineArch) {
    $machineArch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
  }
  $arch = $null
  switch ("$machineArch") {
    "ARM64" { $arch = "arm64" }
    "AMD64" { $arch = "x64" }
  }
  if (-not $arch) {
    [Console]::Error.WriteLine("Unsupported machine architecture '$machineArch' - opencode ships x64 and arm64 Windows builds only.")
    return
  }

  # Older x64 CPUs without AVX2 need the baseline build (same probe as the bash
  # installer: PF_AVX2_INSTRUCTIONS_AVAILABLE = 40).
  $suffix = ""
  if ($arch -eq "x64" -and $nativeLoaded -and -not [OpenCodeInstall.Native]::IsProcessorFeaturePresent(40)) {
    $suffix = "-baseline"
  }
  $filename = "opencode-windows-$arch$suffix.zip"

  if (-not $Version) {
    Write-Host "Fetching latest release from $Repo..."
    try {
      $latest = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
    }
    catch {
      [Console]::Error.WriteLine("Failed to fetch release information from $Repo.")
      [Console]::Error.WriteLine("The repository may have no published release yet, or the GitHub API rate limit was hit.")
      [Console]::Error.WriteLine("Retry later, or pass a version explicitly: install.ps1 -Version <version>")
      return
    }
    $Version = $latest.tag_name
  }
  $Version = $Version -replace "^v", ""

  $url = "https://github.com/$Repo/releases/download/v$Version/$filename"
  $installDir = Join-Path $env:USERPROFILE ".opencode\bin"
  $target = Join-Path $installDir "opencode.exe"
  $aside = "$target.old"
  $tmpDir = Join-Path $env:TEMP "opencode-install-$PID"

  Write-Host "Downloading opencode v$Version (windows-$arch$suffix)..."
  New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
  try {
    $zipPath = Join-Path $tmpDir $filename
    try {
      Invoke-WebRequest -Uri $url -OutFile $zipPath
    }
    catch {
      [Console]::Error.WriteLine("Download failed: $url")
      [Console]::Error.WriteLine("Check that release v$Version exists and includes ${filename}: https://github.com/$Repo/releases")
      return
    }
    Expand-Archive -Path $zipPath -DestinationPath $tmpDir -Force

    Write-Host "Installing to $installDir..."
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
    $movedAside = $false
    if (Test-Path $target) {
      # Windows locks running executables: rename the old binary aside so an
      # upgrade succeeds even while opencode is running.
      Remove-Item $aside -Force -ErrorAction SilentlyContinue
      try {
        Move-Item $target $aside -Force
        $movedAside = $true
      }
      catch {
        [Console]::Error.WriteLine("Could not replace $target. Close running opencode instances and retry.")
        return
      }
    }
    try {
      Copy-Item -Path (Join-Path $tmpDir "opencode.exe") -Destination $target -Force
    }
    catch {
      # Roll back so a failed copy never leaves the user without a working binary.
      if ($movedAside) {
        Move-Item $aside $target -Force -ErrorAction SilentlyContinue
      }
      throw
    }
    if ($movedAside) {
      Remove-Item $aside -Force -ErrorAction SilentlyContinue
    }
  }
  finally {
    Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
  }

  # Append to the user PATH via the registry, preserving REG_EXPAND_SZ entries:
  # [Environment]::SetEnvironmentVariable reads %VAR% references pre-expanded
  # and would write them back frozen.
  $envKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey("Environment")
  try {
    $rawPath = ""
    $kind = [Microsoft.Win32.RegistryValueKind]::ExpandString
    if ($envKey.GetValueNames() -contains "Path") {
      $rawPath = $envKey.GetValue("Path", "", [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
      $kind = $envKey.GetValueKind("Path")
    }
    # Compare entries expanded and without trailing slashes so an existing
    # %USERPROFILE%\.opencode\bin (or a trailing-backslash variant) counts.
    $normalizedInstallDir = [Environment]::ExpandEnvironmentVariables($installDir).TrimEnd("\")
    $alreadyOnPath = @($rawPath -split ";" | Where-Object { $_ } | Where-Object {
        [Environment]::ExpandEnvironmentVariables($_).TrimEnd("\") -ieq $normalizedInstallDir
      }).Count -gt 0
    if (-not $alreadyOnPath) {
      $trimmed = $rawPath.TrimEnd(";")
      $newPath = if ($trimmed) { "$trimmed;$installDir" } else { $installDir }
      $envKey.SetValue("Path", $newPath, $kind)
      if ($nativeLoaded) {
        # Broadcast WM_SETTINGCHANGE so new processes pick up the PATH change.
        $result = [UIntPtr]::Zero
        [OpenCodeInstall.Native]::SendMessageTimeout([IntPtr]0xFFFF, 0x1A, [UIntPtr]::Zero, "Environment", 2, 5000, [ref]$result) | Out-Null
      }
      $env:Path = "$env:Path;$installDir"
      Write-Host "Added $installDir to your user PATH (restart open terminals to pick it up)."
    }
  }
  finally {
    $envKey.Close()
  }

  Write-Host ""
  Write-Host "opencode v$Version installed. Run: opencode"
}
finally {
  $ErrorActionPreference = $prevErrorActionPreference
  $ProgressPreference = $prevProgressPreference
}
