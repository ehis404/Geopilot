param(
    [string]$PackagePath
)

$ErrorActionPreference = "Stop"

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
        $entry = $archive.Entries | Where-Object { $_.FullName -ieq "Config.daml" } | Select-Object -First 1
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
    if (-not $xml) {
        return $false
    }

    $info = $xml.ArcGIS.AddInInfo
    if (-not $info) {
        return $false
    }

    return ($recognizedAddInIds -contains $info.id)
}

if ([string]::IsNullOrWhiteSpace($PackagePath)) {
    $PackagePath = Get-ChildItem -Path $PSScriptRoot -Filter "*.esriAddinX" -File |
        Where-Object {
            $xml = Get-ConfigDamlXml -AddInPath $_.FullName
            $xml -and $xml.ArcGIS.AddInInfo.id -eq $addInId
        } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -ExpandProperty FullName -First 1
}

if ([string]::IsNullOrWhiteSpace($PackagePath) -or -not (Test-Path -LiteralPath $PackagePath)) {
    throw "GeoPilot package not found: $PackagePath"
}

if (-not ((Get-ConfigDamlXml -AddInPath $PackagePath).ArcGIS.AddInInfo.id -eq $addInId)) {
    throw "The selected package is not the current GeoPilot add-in: $PackagePath"
}

if (Test-Path $defaultRoot) {
    $folders = Get-ChildItem -Path $defaultRoot -Directory -ErrorAction SilentlyContinue
    foreach ($folder in $folders) {
        $installedAddins = Get-ChildItem -Path $folder.FullName -Filter "*.esriAddinX" -File -ErrorAction SilentlyContinue
        foreach ($installedAddin in $installedAddins) {
            if (Test-IsGeoPilotAddIn -AddInPath $installedAddin.FullName) {
                Remove-Item -Path $folder.FullName -Recurse -Force -ErrorAction Stop
                break
            }
        }
    }
}

Start-Process -FilePath $PackagePath
