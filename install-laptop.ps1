# ==========================
# Kombinált Telepítő Script
# ==========================

$ErrorActionPreference = 'Stop'

# Winget rész 
Write-Host "Winget telepítése... (Ez sok idő lehet)" -ForegroundColor Cyan
winget upgrade --id Microsoft.WindowsPackageManager -e | Out-Null

$wingetPkgs = @(
    'VideoLAN.VLC',
    'VivaldiTechnologies.Vivaldi',
    'UnityHub.UnityHub',
    'JetBrains.PyCharmCommunity',
    'JetBrains.IntelliJIDEA.Community',
    'Mozilla.Firefox',
    'Microsoft.VisualStudioCode',
    'Microsoft.Teams',
    'LM-Studio.LMStudio',
    'Foxit.FoxitReader',
    'Discord.Discord',
    'EpicGames.EpicGamesLauncher',
    'Crytek.CryEngine',
    'BlenderFoundation.Blender',
    '7zip.7zip'
    'Wargaming.GameCenter'
)

foreach ($pkg in $wingetPkgs) {
    Write-Host "Winget: Telepítés $pkg" -ForegroundColor Green
    winget install --id $pkg --silent --accept-source-agreements --accept-package-agreements | Out-Null
}

# Chocolatey rész (az előző 2. pont)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey telepítése..." -ForegroundColor Cyan
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

$chocoPkgs = @(
    'winamp',
    'rustup',
    'notepadplusplus.install',
    'inkscape',
    'hamachi',
    'git.install',
    'gimp',
    'discord',
    'anaconda3'
)

foreach ($pkg in $chocoPkgs) {
    Write-Host "Chocolatey: Telepítés $pkg" -ForegroundColor Green
    choco install $pkg -y --no-progress | Out-Null
}

Write-Host "`nChocolatey csomag telepítése befejeződött!" -ForegroundColor Yellow

# ==========================================================
# 3 Chocolatey – telepítés (ha szükséges)
# ==========================================================

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey telepítése…" -ForegroundColor Cyan
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# ==========================================================
# 3  Csomaglista – név + célkönyvtár
# ==========================================================

$packagesWithDIR = @(
    @{Name='visualstudio2022community';  Dir='D:\DevTools\VS2022'},
    @{Name='visualstudio2019community';  Dir='D:\DevTools\VS2019'}
)

# ==========================================================
# 4  Egyetlen choco install parancs – minden csomaghoz paraméter
# ==========================================================

$chocoArgs = @()
foreach ($pkg in $packagesWithDIR) {
    # Ha a csomag támogatja az InstallDir paramétert, adjuk meg:
    $chocoArgs += "$($pkg.Name) --params `"/InstallDir:$($pkg.Dir)`""
}

Write-Host "Chocolatey telepítése indul…" -ForegroundColor Cyan
# Az összes csomagot egyetlen parancsban futtatjuk – a `--no-progress` csak a kimenetet takarja.
choco install $chocoArgs -y --no-progress | Out-Null

Write-Host "`nMinden csomag telepítése befejeződött!" -ForegroundColor Yellow
