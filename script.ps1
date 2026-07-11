#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$DownloadFolder = "$env:USERPROFILE\Downloads\GamingVM"

New-Item -ItemType Directory -Path $DownloadFolder -Force | Out-Null

$NvidiaInstaller   = "$DownloadFolder\NvidiaGrid.exe"
$SteamInstaller    = "$DownloadFolder\SteamSetup.exe"
$VibeshineInstaller = "$DownloadFolder\VibeshineSetup.exe"
$ViGEmInstaller    = "$DownloadFolder\ViGEmBusSetup.exe"

Write-Host "Downloading NVIDIA..."
Invoke-WebRequest `
    -Uri "https://download.microsoft.com/download/169e58c8-9099-481e-a9a9-c237a189710c/595.97_grid_win10_win11_server2022_server2025_dch_64bit_international_azure_swl.exe" `
    -OutFile $NvidiaInstaller

Write-Host "Downloading Steam..."
Invoke-WebRequest `
    -Uri "https://cdn.fastly.steamstatic.com/client/installer/SteamSetup.exe" `
    -OutFile $SteamInstaller

Write-Host "Downloading Vibeshine..."
Invoke-WebRequest `
    -Uri "https://github.com/Nonary/vibeshine/releases/download/v1.17.0/VibeshineSetup-v1.17.0.exe" `
    -OutFile $VibeshineInstaller

Write-Host "Downloading ViGEmBus..."
Invoke-WebRequest `
    -Uri "https://github.com/nefarius/ViGEmBus/releases/download/v1.22.0/ViGEmBus_1.22.0_x64_x86_arm64.exe" `
    -OutFile $ViGEmInstaller

Write-Host "Opening NVIDIA and Vibeshine installers..."
Start-Process $NvidiaInstaller
Start-Process $VibeshineInstaller

Write-Host "Installing Steam and ViGEmBus automatically..."

$SteamProcess = Start-Process `
    -FilePath $SteamInstaller `
    -ArgumentList "/S" `
    -PassThru

$ViGEmProcess = Start-Process `
    -FilePath $ViGEmInstaller `
    -ArgumentList "/qn /norestart" `
    -PassThru

$SteamProcess.WaitForExit()
$ViGEmProcess.WaitForExit()

if ($ViGEmProcess.ExitCode -notin @(0, 1641, 3010)) {
    Write-Warning "ViGEmBus returned exit code $($ViGEmProcess.ExitCode)."
}
else {
    Write-Host "ViGEmBus installed successfully." -ForegroundColor Green
}

$SteamPaths = @(
    "${env:ProgramFiles(x86)}\Steam\steam.exe",
    "$env:ProgramFiles\Steam\steam.exe"
)

$SteamExe = $SteamPaths |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1

if ($SteamExe) {
    Write-Host "Opening Steam so it can update..."
    Start-Process $SteamExe
}
else {
    Write-Warning "Steam executable could not be found."
}

Write-Host "Done. Complete the NVIDIA and Vibeshine setup windows."
