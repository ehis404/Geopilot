<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&height=210&color=0:07111f,30:0f766e,65:2563eb,100:f59e0b&text=GeoPilot&fontColor=ffffff&fontSize=58&fontAlign=50&fontAlignY=42&animation=fadeIn" alt="GeoPilot banner" />

<img src="https://readme-typing-svg.demolab.com?font=Segoe+UI&weight=700&size=22&duration=2200&pause=900&center=true&vCenter=true&width=900&color=E5EDF8&lines=Map+Snapshot;Export+KMZ;Geo+Report;Google+Maps+Link;Media+to+GIS;Ain+Alabid+Offset;Ain+Alabid+Reverse" alt="GeoPilot animated subtitle" />

<p><strong>أداة احترافية داخل ArcGIS Pro للمشاركة السريعة، تصدير KMZ، الروابط الذكية، والتقارير الجغرافية في تجربة أخف وأسرع.</strong></p>
<p><strong>A professional ArcGIS Pro toolkit for fast sharing, KMZ export, smart links, and streamlined geographic reporting.</strong></p>

[![ArcGIS Pro](https://img.shields.io/badge/ArcGIS%20Pro-3.4%2B-2563eb?style=for-the-badge)](https://www.esri.com/en-us/arcgis/products/arcgis-pro/overview)
[![Version](https://img.shields.io/badge/Version-v1.0.52-f59e0b?style=for-the-badge)](https://github.com/ehis404/Geopilot/releases/tag/v1.0.52)

[![Install GeoPilot](https://img.shields.io/badge/Install-GeoPilot-0f766e?style=for-the-badge&logo=powershell)](https://github.com/ehis404/Geopilot/releases/download/v1.0.52/Install-GeoPilot.ps1)
[![Open Release](https://img.shields.io/badge/Open-Release%20Page-1d4ed8?style=for-the-badge)](https://github.com/ehis404/Geopilot/releases/tag/v1.0.52)

</div>

---

## GeoPilot Components

### Share Group

| Tool | What It Does | Available Channels |
|---|---|---|
| `Map Snapshot` | Captures the current map view as an image and prepares it for fast sharing | `Outlook`, `Gmail`, `WhatsApp` |
| `Export KMZ` | Exports the current selection to a `KMZ` file for spatial sharing and external use | `Outlook`, `Gmail`, `WhatsApp` |
| `Geo Report` | Generates a location-based report from a clicked point on the map | `WhatsApp`, `Gmail`, `Outlook`, `Copy Only` |

### Transform Group

| Tool | What It Does |
|---|---|
| `KMZ → Feature Class` | Converts `KMZ/KML` content into feature classes that can be used directly inside ArcGIS Pro |
| `Ain Alabid Offset` | Applies the custom XY offset workflow to supported layers |
| `Ain Alabid Reverse` | Reverses the custom offset workflow and restores the opposite movement |

### Locate Group

| Tool | What It Does |
|---|---|
| `Google Maps Link` | Creates direct Google Maps URLs from layer geometry and supports different projection handling |
| `Media to GIS` | Extracts coordinates from geotagged photos and videos, applies OCR when needed, and creates mapped GIS points |

### Integrated Mapping Components

| Component | What It Does |
|---|---|
| `Custom Basemap Gallery` | Adds extra basemap entries for quicker visual context and comparison workflows inside ArcGIS Pro |
| `Info Panel` | Displays product identity and direct communication links for the tool owner |

## Install GeoPilot

<div align="center">

| Option | Access |
|---|---|
| Recommended installer | [Install-GeoPilot.ps1](https://github.com/ehis404/Geopilot/releases/download/v1.0.52/Install-GeoPilot.ps1) |
| Manual package | [GeoPilot-v1.0.52.esriAddinX](https://github.com/ehis404/Geopilot/releases/download/v1.0.52/GeoPilot-v1.0.52.esriAddinX) |
| Release Page | [View Release v1.0.52](https://github.com/ehis404/Geopilot/releases/tag/v1.0.52) |

</div>

The recommended installer automatically downloads the latest GeoPilot package, removes previous GeoPilot versions, and launches the new ArcGIS Pro add-in installation.

## Workflow Summary

| Area | Included Items |
|---|---|
| Sharing | `Map Snapshot`, `Export KMZ`, `Geo Report` |
| Conversion | `KMZ → Feature Class` |
| Locate | `Google Maps Link`, `Media to GIS` |
| Projection | `Ain Alabid Offset`, `Ain Alabid Reverse` |
| Mapping | `Custom Basemap Gallery` |

## Installation

1. Close `ArcGIS Pro`
2. Download [Install-GeoPilot.ps1](https://github.com/ehis404/Geopilot/releases/download/v1.0.52/Install-GeoPilot.ps1)
3. Right-click `Install-GeoPilot.ps1` and choose **Run with PowerShell**
4. The installer automatically downloads the latest package and removes older GeoPilot versions
5. Confirm the ArcGIS Pro add-in installation
6. Open `ArcGIS Pro` again

If Windows blocks direct script execution, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-GeoPilot.ps1
```

## Release Snapshot

| Item | Value |
|---|---|
| Product | `GeoPilot` |
| Version | `v1.0.52` |
| Package | `ArcGIS Pro Add-In` |
| Target | `ArcGIS Pro 3.4+` |

<details>
<summary><strong>Additional Notes</strong></summary>

- Built for Windows and ArcGIS Pro environments
- The recommended installer downloads the current package and removes older GeoPilot add-ins before installation
- Some basemap-related capabilities depend on third-party services
- This repository is intentionally lightweight and does not publish source code

</details>

---

## Contact

<div align="center">

[![Email](https://img.shields.io/badge/Email-muhannad4gis%40gmail.com-0f172a?style=for-the-badge)](mailto:muhannad4gis@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Muhannad%20Alzahrani-0a66c2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/muhannad-d-alzahrani-65b018234)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-%2B966%2050%20756%209367-15803d?style=for-the-badge&logo=whatsapp)](https://web.whatsapp.com/send/?phone=966507569367&text&type=phone_number&app_absent=0)

</div>



