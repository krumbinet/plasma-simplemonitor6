/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

// GPU temperatures for every GPU the sensor system knows about.
Column {
    id: gpuTempList

    property int direction: Qt.LeftToRight
    LayoutMirroring.enabled: direction === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property var model                // sysData.gpuTempModel
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
        model: gpuTempList.model
        delegate: TempRow {
            required property real val
            required property bool avail
            required property string gpuLabel

            visible: avail
            width: gpuTempList.width
            label: gpuLabel
            value: val
            maxTemp: 100
            tempUnit: gpuTempList.tempUnit
            highTemp: gpuTempList.highTemp
            criticalTemp: gpuTempList.criticalTemp
            indicatorHeight: gpuTempList.indicatorHeight
            fontFamily: doppioOneRegular.name
        }
    }
}
