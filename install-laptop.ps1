# ==========================
# Kombinált Telepítő Script
# ==========================

$ErrorActionPreference = 'Stop'

# Winget rész 
Write-Host "Winget telepítése... (Ez sok idő lehet)" -ForegroundColor Cyan
winget upgrade --id Microsoft.WindowsPackageManager -e --accept-source-agreements --accept-package-agreements

$wingetPkgs = @(
    'VideoLAN.VLC',
    'Unity.UnityHub',
    'JetBrains.PyCharm.Community',
    'JetBrains.IntelliJIDEA.Community',
    'Mozilla.Firefox',
    'Microsoft.VisualStudioCode',
    'Microsoft.Teams',
    'Foxit.FoxitReader',
    'Discord.Discord',
    'EpicGames.EpicGamesLauncher',
    'BlenderFoundation.Blender',
    '7zip.7zip'
    'Wargaming.GameCenter'
)

foreach ($pkg in $wingetPkgs) {
    Write-Host "Winget: Telepítés $pkg" -ForegroundColor Green
    winget install --id $pkg --silent --accept-source-agreements --accept-package-agreements
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
    'rust',
    'notepadplusplus.install',
    'inkscape',
    'hamachi',
    'git.install',
    'gimp',
    'anaconda3',
    'lm-studio',
    'vivaldi'
)

foreach ($pkg in $chocoPkgs) {
    Write-Host "Chocolatey: Telepítés $pkg" -ForegroundColor Green
    #choco install $pkg -y --no-progress | Out-Null
    choco install $pkg -y
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

foreach ($pkg in $packagesWithDIR) {
    # Ha a csomag támogatja az InstallDir paramétert, adjuk meg:
    choco install $pkg.Name -y  --params /InstallDir:$pkg.Dir
}

Write-Host "Chocolatey telepítése indul…" -ForegroundColor Cyan
# Az összes csomagot egyetlen parancsban futtatjuk – a `--no-progress` csak a kimenetet takarja.
#choco install $chocoArgs -y --no-progress | Out-Null

Write-Host "`nMinden csomag telepítése befejeződött!" -ForegroundColor Yellow
