/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import QtQuick.Layouts

// Memory or swap usage. All values in GiB.
Item {
    id: memArea

    property real memTotal: 0.0
    property real memUsed: 0.0
    property real memFree: Math.max(0, memTotal - memUsed)
    property alias memTypeLabel: memType.text

    implicitWidth: memColumn.implicitWidth
    implicitHeight: memColumn.implicitHeight

    FontLoader {
        id: doppioOneRegular
        source: "../../fonts/Doppio_One/DoppioOne-Regular.ttf"
    }

    ColumnLayout {
        id: memColumn

        spacing: 2
        anchors.fill: parent

        RowLayout {
            spacing: 3
            Text {
                id: memType
                text: i18n("Mem:")
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "#ffdd55"
            }
            Text {
                text: i18n("%1 GiB", memArea.memTotal.toFixed(2))
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "white"
            }
        }

        RowLayout {
            id: memoryInfoLabels
            spacing: 3
            property int fontSize: 8
            Text {
                text: i18n("Used:")
                color: "red"
                font.pointSize: memoryInfoLabels.fontSize
            }
            Text {
                text: i18n("%1 GiB", memArea.memUsed.toFixed(2))
                color: "white"
                font.pointSize: memoryInfoLabels.fontSize
            }
            Text {
                text: i18n("Free:")
                color: "#7ec264"
                font.pointSize: memoryInfoLabels.fontSize
            }
            Text {
                text: i18n("%1 GiB", memArea.memFree.toFixed(2))
                color: "white"
                font.pointSize: memoryInfoLabels.fontSize
            }
        }

        Rectangle {
            height: 7
            Layout.fillWidth: true
            color: "#7ec264"
            Rectangle {
                anchors.left: parent.left
                height: parent.height
                width: memArea.memTotal > 0
                       ? Math.min(1, memArea.memUsed / memArea.memTotal) * parent.width
                       : 0
                color: "red"
            }
        }
    }
}
