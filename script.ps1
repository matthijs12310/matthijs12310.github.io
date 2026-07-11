#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$WorkDir = Join-Path $env:TEMP "GamingVM-Setup"
New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Apps = @(
    @{
        Name = "NVIDIA GRID"
        Url  = "https://download.microsoft.com/download/169e58c8-9099-481e-a9a9-c237a189710c/595.97_grid_win10_win11_server2022_server2025_dch_64bit_international_azure_swl.exe"
        File = "$WorkDir\NvidiaGrid.exe"
        Args = "-s -noreboot"
    },
    @{
        Name = "Steam"
        Url  = "https://cdn.fastly.steamstatic.com/client/installer/SteamSetup.exe"
        File = "$WorkDir\SteamSetup.exe"
        Args = "/S"
    },
    @{
        Name = "Vibeshine"
        Url  = "https://github.com/Nonary/vibeshine/releases/download/v1.17.0/VibeshineSetup-v1.17.0.exe"
        File = "$WorkDir\VibeshineSetup.exe"
        Args = "/S"
    }
)

Write-Host "Downloading and installing everything in parallel..." -ForegroundColor Cyan

$Jobs = foreach ($App in $Apps) {
    Start-Job -ArgumentList $App -ScriptBlock {
        param($App)

        $ErrorActionPreference = "Stop"
        $ProgressPreference = "SilentlyContinue"

        Write-Output "Downloading $($App.Name)..."
        Invoke-WebRequest -Uri $App.Url -OutFile $App.File -UseBasicParsing

        Write-Output "Installing $($App.Name)..."
        $Process = Start-Process `
            -FilePath $App.File `
            -ArgumentList $App.Args `
            -Wait `
            -PassThru

        if ($Process.ExitCode -notin @(0, 1641, 3010)) {
            throw "$($App.Name) failed with exit code $($Process.ExitCode)"
        }

        Write-Output "$($App.Name) completed."
    }
}

while ($Jobs.State -contains "Running" -or $Jobs.State -contains "NotStarted") {
    foreach ($Job in $Jobs) {
        Receive-Job $Job
    }

    Start-Sleep -Seconds 2
    $Jobs = Get-Job
}

foreach ($Job in $Jobs) {
    Receive-Job $Job

    if ($Job.State -eq "Failed") {
        Write-Host "$($Job.Name) failed:" -ForegroundColor Red
        Write-Host $Job.ChildJobs[0].JobStateInfo.Reason.Message -ForegroundColor Red
    }
}

Remove-Job $Jobs -Force
Remove-Item $WorkDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Installation finished. Restart Windows to activate the GPU driver." `
    -ForegroundColor Green
