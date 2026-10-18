/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

// CPU temperatures: one line per core, or a single average/maximum line.
Column {
    id: coreTempList

    property int direction: Qt.LeftToRight
    LayoutMirroring.enabled: direction === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property var model                // sysData.coreTempModel
    property int mode: 0              // 0 = per core, 1 = average, 2 = maximum
    property real avgTemp: NaN
    property real maxTemp: NaN
    property int highTemp: 70
    property int criticalTemp: 85
    property int tempUnit: 0
    property int indicatorHeight: 10

    spacing: 2


    FontLoader {
        id: doppioOneRegular
        source: "../../fonts/Doppio_One/DoppioOne-Regular.ttf"
    }

    Repeater {
        model: coreTempList.mode === 0 ? coreTempList.model : null
        delegate: TempRow {
            required property int index
            required property real val
            required property bool avail

            visible: avail
            width: coreTempList.width
            label: i18n("Core %1:", index)
            value: val
            tempUnit: coreTempList.tempUnit
            highTemp: coreTempList.highTemp
            criticalTemp: coreTempList.criticalTemp
            indicatorHeight: coreTempList.indicatorHeight
            fontFamily: doppioOneRegular.name
        }
    }

    TempRow {
        readonly property real shown: coreTempList.mode === 2 ? coreTempList.maxTemp : coreTempList.avgTemp
        visible: coreTempList.mode !== 0 && !isNaN(shown)
        width: coreTempList.width
        label: coreTempList.mode === 2 ? i18n("CPU max:") : i18n("CPU:")
        value: isNaN(shown) ? 0 : shown
        tempUnit: coreTempList.tempUnit
        highTemp: coreTempList.highTemp
        criticalTemp: coreTempList.criticalTemp
        indicatorHeight: coreTempList.indicatorHeight
        fontFamily: doppioOneRegular.name
    }
}
