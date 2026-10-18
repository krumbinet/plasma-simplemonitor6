/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

// Big digital clock: hours, minutes, seconds in decreasing size.
Item {
    id: timePicker

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    implicitWidth: secs.x + secs.width
    implicitHeight: hour.implicitHeight - 11

    FontLoader {
        id: playRegular
        source: "../../fonts/Play/Play-Regular.ttf"
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var dateTime = new Date()
            hour.text = Qt.formatDateTime(dateTime, "hh") + ":"
            mins.text = Qt.formatDateTime(dateTime, "mm") + ":"
            secs.text = Qt.formatDateTime(dateTime, "ss")
        }
    }

    Text {
        id: hour
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: 44
        text: "00:"
        font {
            family: playRegular.name
            pointSize: 30
        }
        color: "white"
    }
    Text {
        id: mins
        anchors.left: hour.right
        anchors.bottom: parent.bottom
        height: 29
        text: "00:"
        font {
            family: playRegular.name
            pointSize: 20
        }
        color: "#cdde87"
    }
    Text {
        id: secs
        anchors.left: mins.right
        anchors.bottom: parent.bottom
        height: 21
        text: "00"
        font {
            family: playRegular.name
            pointSize: 15
        }
        color: "#ebff9d"
    }
}
