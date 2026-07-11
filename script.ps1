#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$DownloadDirectory = Join-Path $env:TEMP "GamingVM-Setup"

$Downloads = @{
    Nvidia = @{
        Url  = "https://download.microsoft.com/download/169e58c8-9099-481e-a9a9-c237a189710c/595.97_grid_win10_win11_server2022_server2025_dch_64bit_international_azure_swl.exe"
        File = Join-Path $DownloadDirectory "NvidiaGrid595.97.exe"
        Args = "-s -noreboot"
    }

    Steam = @{
        Url  = "https://cdn.fastly.steamstatic.com/client/installer/SteamSetup.exe"
        File = Join-Path $DownloadDirectory "SteamSetup.exe"
        Args = "/S"
    }

    Vibeshine = @{
        Url  = "https://github.com/Nonary/vibeshine/releases/download/v1.17.0/VibeshineSetup-v1.17.0.exe"
        File = Join-Path $DownloadDirectory "VibeshineSetup-v1.17.0.exe"
        Args = "/S"
    }
}

function Write-Step {
    param([string]$Message)

    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Download-File {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Destination
    )

    Write-Step "Downloading $Name"

    Invoke-WebRequest `
        -Uri $Url `
        -OutFile $Destination `
        -UseBasicParsing

    if (-not (Test-Path $Destination)) {
        throw "$Name download failed."
    }

    $SizeMB = [math]::Round((Get-Item $Destination).Length / 1MB, 1)
    Write-Host "Downloaded $Name ($SizeMB MB)" -ForegroundColor Green
}

function Install-Application {
    param(
        [string]$Name,
        [string]$Installer,
        [string]$Arguments
    )

    Write-Step "Installing $Name"

    $Process = Start-Process `
        -FilePath $Installer `
        -ArgumentList $Arguments `
        -Wait `
        -PassThru

    # 0    = Success
    # 1641 = Success; reboot initiated
    # 3010 = Success; reboot required
    if ($Process.ExitCode -notin @(0, 1641, 3010)) {
        throw "$Name installer returned exit code $($Process.ExitCode)."
    }

    Write-Host "$Name installation completed." -ForegroundColor Green
}

try {
    Write-Host "Gaming VM setup" -ForegroundColor Yellow
    Write-Host "Temporary directory: $DownloadDirectory"

    New-Item `
        -ItemType Directory `
        -Path $DownloadDirectory `
        -Force | Out-Null

    # Ensure modern HTTPS works in Windows PowerShell.
    [Net.ServicePointManager]::SecurityProtocol = `
        [Net.ServicePointManager]::SecurityProtocol -bor `
        [Net.SecurityProtocolType]::Tls12

    foreach ($Name in @("Nvidia", "Steam", "Vibeshine")) {
        Download-File `
            -Name $Name `
            -Url $Downloads[$Name].Url `
            -Destination $Downloads[$Name].File
    }

    # Install the NVIDIA GRID driver first.
    Install-Application `
        -Name "NVIDIA GRID driver 595.97" `
        -Installer $Downloads.Nvidia.File `
        -Arguments $Downloads.Nvidia.Args

    Install-Application `
        -Name "Steam" `
        -Installer $Downloads.Steam.File `
        -Arguments $Downloads.Steam.Args

    Install-Application `
        -Name "Vibeshine 1.17.0" `
        -Installer $Downloads.Vibeshine.File `
        -Arguments $Downloads.Vibeshine.Args

    Write-Step "Cleaning up installers"
    Remove-Item $DownloadDirectory -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "Setup completed successfully." -ForegroundColor Green
    Write-Host "Restart Windows before using the NVIDIA GPU." -ForegroundColor Yellow

    $Restart = Read-Host "Restart now? [Y/N]"
    if ($Restart -match "^[Yy]") {
        Restart-Computer -Force
    }
}
catch {
    Write-Host ""
    Write-Host "SETUP FAILED" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "Downloaded files remain in: $DownloadDirectory"
    exit 1
}
