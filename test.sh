#!/bin/sh
# SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Installs the current state and opens the widget in its own window.
# QML errors are printed to this terminal.
set -e
cd "$(dirname "$0")"
ID=$(python3 -c "import json;print(json.load(open('package/metadata.json'))['KPlugin']['Id'])")
./install.sh >/dev/null
if command -v plasmoidviewer >/dev/null; then
    exec plasmoidviewer -a "$ID" -f planar -l floating
else
    exec plasmawindowed "$ID"
fi
