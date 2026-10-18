# Change Log
All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [0.7.1] - 2026-10-18
First public release.

### Changed
- Final plugin ID `io.github.krumbinet.simplemonitor`, project page
  https://github.com/krumbinet/plasma-simplemonitor6

## [0.7.0] - 2026-10-18 (not published)
First release for KDE Plasma 6 (port of plasma-simpleMonitor 0.6.x).

### Changed
- Ported to Plasma 6 / Qt 6: `metadata.json`, `PlasmoidItem`, Qt 6 imports.
- Sensor data now comes from `ksystemstats` (`org.kde.ksysguard.sensors`)
  instead of the removed `systemmonitor` data engine.
- Memory "used" is the application memory reported by ksystemstats
  (same meaning as before: used minus buffers and cache).
- Distribution and kernel information come from the sensor system instead of
  reading `/etc/os-release` and `/proc/version` (blocked in Qt 6 QML).
- GPU temperatures for all GPUs known to ksystemstats (NVIDIA, AMD, Intel)
  instead of calling `nvidia-smi`, `aticonfig` and `amdconfig`.
- Settings pages rebuilt with Kirigami FormLayout and QtQuick Controls 2.
- Logo scaling is toggled from the widget's context menu.
- Plugin ID changed to `io.github.krumbinet.simplemonitor`, translation files
  moved to `po/<lang>.po` and are compiled into the package.
- Default warning thresholds raised to 70 °C (high) and 85 °C (critical).

### Added
- Option to show CPU temperature per core, as average or as maximum.
- Fallback to the logo icon shipped by the distribution, then Tux.
- Minimalistic skin selectable in the settings, new skin previews.
- Debian logo selectable in the settings.
- German translation.
- `build.sh`, `install.sh`, `uninstall.sh`, `test.sh`.

### Fixed
- Broken layouts in the Default and Column skins of the last master
  (nested temperature lists, invalid properties).
- Average CPU temperature colouring used high/critical the wrong way round.

### Removed
- Hardware specific code for coretemp/k10temp/atk sensors.
- CMake build (the widget is pure QML; translations are built by `build.sh`).

## [0.6] - 2017-03-19
See the history of https://github.com/dhabyx/plasma-simpleMonitor
