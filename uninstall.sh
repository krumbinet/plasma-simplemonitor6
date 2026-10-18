#!/bin/sh
# SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
# SPDX-License-Identifier: GPL-3.0-or-later
set -e
cd "$(dirname "$0")"
ID=$(python3 -c "import json;print(json.load(open('package/metadata.json'))['KPlugin']['Id'])")
kpackagetool6 -t Plasma/Applet -r "$ID"
