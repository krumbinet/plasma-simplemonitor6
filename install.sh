#!/bin/sh
# SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Installs or upgrades the widget for the current user (no root needed).
set -e
cd "$(dirname "$0")"
ID=$(python3 -c "import json;print(json.load(open('package/metadata.json'))['KPlugin']['Id'])")
./build.sh
if kpackagetool6 -t Plasma/Applet -s "$ID" >/dev/null 2>&1; then
    kpackagetool6 -t Plasma/Applet -u package
else
    kpackagetool6 -t Plasma/Applet -i package
fi
echo "Done. Add it via right click on the desktop -> Add or Manage Widgets -> \"Simple System Monitor\"."
echo "If an already placed widget does not pick up the change: systemctl --user restart plasma-plasmashell"
