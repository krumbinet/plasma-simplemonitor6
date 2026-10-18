#!/bin/sh
# SPDX-FileCopyrightText: 2017 Konstantin Shtepa
# SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Updates the translation template and merges it into all po/<lang>.po files.
#   ./Messages.sh        update template and all languages
#   ./Messages.sh fr     additionally start a new French translation
# Requires: gettext (xgettext, msgmerge), python3 (only for reading metadata.json)

set -e
cd "$(dirname "$0")"

ID=$(python3 -c "import json;print(json.load(open('../package/metadata.json'))['KPlugin']['Id'])")
VERSION=$(python3 -c "import json;print(json.load(open('../package/metadata.json'))['KPlugin']['Version'])")
DOMAIN="plasma_applet_$ID"
POT="$DOMAIN.pot"

find ../package -name '*.qml' -o -name '*.js' | sort > files.tmp
xgettext --from-code=UTF-8 -C --kde \
    -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 \
    --package-name="plasma-simpleMonitor" --package-version="$VERSION" \
    --msgid-bugs-address="https://github.com/krumbinet/plasma-simplemonitor6/issues" \
    -f files.tmp -o "$POT"
rm -f files.tmp
sed -i -e 's/charset=CHARSET/charset=UTF-8/' \
       -e 's/SOME DESCRIPTIVE TITLE./plasma-simpleMonitor translation template./' \
       -e "s/Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER/Copyright (C) 2013-2016 Dhaby Xiloj, Konstantin Shtepa; 2026 Plasma 6 port contributors/" \
       "$POT"

if [ -n "$1" ] && [ ! -f "$1.po" ]; then
    msginit --no-translator -l "$1" -i "$POT" -o "$1.po"
fi

for po in *.po; do
    [ -f "$po" ] || continue
    echo "Merging $POT -> $po"
    msgmerge -q -U --backup=none "$po" "$POT"
done
