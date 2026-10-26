# Bundled fonts (plan D16)

The app loads every font from this folder (`mainwin.AppOptions`); nothing comes from the
system fonts folder. Segoe UI, Segoe Fluent Icons and Consolas are licensed for use on Windows,
not for redistribution, so none of them ships here.

| File | Role | Licence | Source |
| --- | --- | --- | --- |
| `Inter-Regular.ttf`, `Inter-Bold.ttf` | UI, UI bold | SIL OFL 1.1 (`OFL-Inter.txt`) | rsms/inter v4.1 release zip, `extras/ttf/` (SHA-256 below) |
| `CascadiaMono.ttf` | editor / mono | SIL OFL 1.1 (`OFL-Cascadia.txt`) | Microsoft Cascadia Code project (copy shipped with Windows 11) |
| `PsIcons.ttf` | icons | MIT (`LICENSE-FluentSystemIcons.txt`) | PsPlatform `assets/fonts`: a subset of Fluent UI System Icons remapped onto tiko's Segoe codepoints by `build-psicons.py` there. New icons are added with that script. |

SHA-256:
- Inter-Regular.ttf `40d692fce188e4471e2b3cba937be967878f631ad3ebbbdcd587687c7ebe0c82`
- Inter-Bold.ttf `288316099b1e0a47a4716d159098005eef7c0066921f34e3200393dbdb01947f`
