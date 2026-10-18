/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import QtQuick.Layouts

// Day name, day number and month (in the system language).
ColumnLayout {
    id: datePicker

    spacing: 0

    FontLoader {
        id: michroma
        source: "../../fonts/Michroma/Michroma.ttf"
    }
    FontLoader {
        id: playBold
        source: "../../fonts/Play/Play-Bold.ttf"
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var dateTime = new Date()
            var locale = Qt.locale()
            dayName.text = locale.toString(dateTime, "ddd")
            dayNumber.text = locale.toString(dateTime, "dd")
            monthName.text = locale.toString(dateTime, "MMM")
        }
    }

    Text {
        id: dayName
        font.pointSize: 14
        color: "white"
        font.capitalization: Font.AllLowercase
        Layout.bottomMargin: -20
    }

    Row {
        Text {
            id: dayNumber
            font {
                family: michroma.name
                pointSize: 40
            }
            color: "#999"
        }
        Text {
            id: monthName
            anchors.bottom: parent.bottom
            font {
                family: playBold.name
                capitalization: Font.AllUppercase
                pointSize: 16
            }
            color: "white"
        }
    }
}
