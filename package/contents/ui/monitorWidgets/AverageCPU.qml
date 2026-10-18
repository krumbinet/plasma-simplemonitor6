/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import QtQuick.Layouts

import "../../code/code.js" as Code

// Total CPU load and average temperature (used by the minimalistic skin).
Item {
    id: avgCpu

    property real avgLoad: 0
    property real avgTemp: NaN
    property int tempUnit: 0
    property int highTemp: 70
    property int criticalTemp: 85

    implicitWidth: cpuColumn.implicitWidth
    implicitHeight: cpuColumn.implicitHeight

    FontLoader {
        id: doppioOneRegular
        source: "../../fonts/Doppio_One/DoppioOne-Regular.ttf"
    }

    ColumnLayout {
        id: cpuColumn

        spacing: 2
        anchors.fill: parent

        RowLayout {
            spacing: 3
            Text {
                text: i18n("CPU:")
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "#ffdd55"
            }
            Text {
                text: i18n("%1%", String(Math.round(avgCpu.avgLoad)))
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: avgCpu.avgLoad < 80 ? "white" : "red"
            }
            Text {
                visible: !isNaN(avgCpu.avgTemp)
                text: Code.formatTemp(avgCpu.avgTemp, avgCpu.tempUnit)
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: avgCpu.avgTemp >= avgCpu.criticalTemp ? "red"
                     : avgCpu.avgTemp >= avgCpu.highTemp ? "#ffcc00"
                     : "white"
            }
        }

        Rectangle {
            height: 5
            Layout.fillWidth: true
            color: "#7ec264"
            Rectangle {
                anchors.left: parent.left
                height: parent.height
                width: Math.min(1, Math.max(0, avgCpu.avgLoad / 100)) * parent.width
                color: "red"
            }
        }
    }
}
