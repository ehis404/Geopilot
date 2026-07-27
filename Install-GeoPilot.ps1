param(
    [string]$PackagePath
)

$ErrorActionPreference = "Stop"

$repository = "ehis404/Geopilot"
$addInId = "{2EAC9C88-7D43-4F74-B7E8-07F51E8B1D13}"
$legacyAddInIds = @(
    "{F41F0E06-AEDE-4A95-9392-4C568F925D53}"
)
$recognizedAddInIds = @($addInId) + $legacyAddInIds
$defaultRoot = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "ArcGIS\AddIns\ArcGISPro"

function Get-ConfigDamlXml {
    param(
        [Parameter(Mandatory = $true)]
        [string]$AddInPath
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = $null

    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($AddInPath)
        $entry = $archive.Entries |
            Where-Object { $_.FullName -ieq "Config.daml" } |
            Select-Object -First 1

        if (-not $entry) {
            return $null
        }

        $reader = New-Object System.IO.StreamReader($entry.Open())
        try {
            [xml]$xml = $reader.ReadToEnd()
            return $xml
        }
        finally {
            $reader.Dispose()
        }
    }
    catch {
        return $null
    }
    finally {
        if ($archive) {
            $archive.Dispose()
        }
    }
}

function Test-IsGeoPilotAddIn {
    param(
        [Parameter(Mandatory = $true)]
        [string]$AddInPath
    )

    $xml = Get-ConfigDamlXml -AddInPath $AddInPath
    if (-not $xml -or -not $xml.ArcGIS.AddInInfo) {
        return $false
    }

    return ($recognizedAddInIds -contains $xml.ArcGIS.AddInInfo.id)
}

function Find-AdjacentPackage {
    $packages = Get-ChildItem -Path $PSScriptRoot -Filter "*.esriAddinX" -File -ErrorAction SilentlyContinue |
        Where-Object { Test-IsGeoPilotAddIn -AddInPath $_.FullName } |
        Sort-Object LastWriteTime -Descending

    return $packages | Select-Object -ExpandProperty FullName -First 1
}

function Download-LatestPackage {
    Write-Host "Downloading the latest GeoPilot release..." -ForegroundColor Cyan

    [Net.ServicePointManager]::SecurityProtocol =
        [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $headers = @{ "User-Agent" = "GeoPilot-Installer" }
    $release = Invoke-RestMethod `
        -Uri "https://api.github.com/repos/$repository/releases/latest" `
        -Headers $headers

    $asset = $release.assets |
        Where-Object { $_.name -like "GeoPilot-v*.esriAddinX" } |
        Select-Object -First 1

    if (-not $asset) {
        throw "The latest GeoPilot release does not contain an ArcGIS Pro add-in package."
    }

    $downloadRoot = Join-Path ([IO.Path]::GetTempPath()) "GeoPilot\Downloads\$($release.tag_name)"
    New-Item -Path $downloadRoot -ItemType Directory -Force | Out-Null

    $downloadPath = Join-Path $downloadRoot $asset.name
    Invoke-WebRequest `
        -Uri $asset.browser_download_url `
        -Headers $headers `
        -OutFile $downloadPath `
        -UseBasicParsing

    return $downloadPath
}

function Resolve-GeoPilotPackage {
    param(
        [string]$RequestedPath
    )

    if (-not [string]::IsNullOrWhiteSpace($RequestedPath)) {
        if (-not (Test-Path -LiteralPath $RequestedPath)) {
            throw "GeoPilot package not found: $RequestedPath"
        }

        return (Resolve-Path -LiteralPath $RequestedPath).Path
    }

    $adjacentPackage = Find-AdjacentPackage
    if (-not [string]::IsNullOrWhiteSpace($adjacentPackage)) {
        return $adjacentPackage
    }

    return Download-LatestPackage
}

function Remove-InstalledGeoPilotVersions {
    if (-not (Test-Path -LiteralPath $defaultRoot)) {
        return 0
    }

    $removedCount = 0
    $folders = Get-ChildItem -LiteralPath $defaultRoot -Directory -ErrorAction SilentlyContinue

    foreach ($folder in $folders) {
        $installedAddIns = Get-ChildItem `
            -LiteralPath $folder.FullName `
            -Filter "*.esriAddinX" `
            -File `
            -Recurse `
            -ErrorAction SilentlyContinue

        $containsGeoPilot = $installedAddIns |
            Where-Object { Test-IsGeoPilotAddIn -AddInPath $_.FullName } |
            Select-Object -First 1

        if ($containsGeoPilot) {
            Remove-Item -LiteralPath $folder.FullName -Recurse -Force
            $removedCount++
        }
    }

    return $removedCount
}

if (Get-Process -Name "ArcGISPro" -ErrorAction SilentlyContinue) {
    throw "Close ArcGIS Pro before installing GeoPilot, then run this installer again."
}

$PackagePath = Resolve-GeoPilotPackage -RequestedPath $PackagePath
$packageXml = Get-ConfigDamlXml -AddInPath $PackagePath

if (-not $packageXml -or $packageXml.ArcGIS.AddInInfo.id -ne $addInId) {
    throw "The selected file is not a valid current GeoPilot package: $PackagePath"
}

$version = $packageXml.ArcGIS.AddInInfo.version
Write-Host "Installing GeoPilot v$version..." -ForegroundColor Cyan

$removedVersions = Remove-InstalledGeoPilotVersions
if ($removedVersions -gt 0) {
    Write-Host "Removed $removedVersions previous GeoPilot installation(s)." -ForegroundColor Yellow
}
else {
    Write-Host "No previous GeoPilot installation was found."
}

Unblock-File -LiteralPath $PackagePath -ErrorAction SilentlyContinue
Start-Process -FilePath $PackagePath

Write-Host "GeoPilot v$version is ready for ArcGIS Pro installation." -ForegroundColor Green
