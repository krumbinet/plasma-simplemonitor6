#!/bin/sh
# SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Compiles the translations into the package and builds build/<name>-<version>.plasmoid
# Requires: gettext (msgfmt), zip, python3

set -e
cd "$(dirname "$0")"

ID=$(python3 -c "import json;print(json.load(open('package/metadata.json'))['KPlugin']['Id'])")
VERSION=$(python3 -c "import json;print(json.load(open('package/metadata.json'))['KPlugin']['Version'])")
DOMAIN="plasma_applet_$ID"

rm -rf package/contents/locale
for po in po/*.po; do
    lang=$(basename "$po" .po)
    mkdir -p "package/contents/locale/$lang/LC_MESSAGES"
    msgfmt --check -o "package/contents/locale/$lang/LC_MESSAGES/$DOMAIN.mo" "$po"
done

mkdir -p build
OUT="build/plasma-simplemonitor-$VERSION.plasmoid"
rm -f "$OUT"
(cd package && zip -q -r -X "../$OUT" metadata.json contents)
echo "Built $OUT"
