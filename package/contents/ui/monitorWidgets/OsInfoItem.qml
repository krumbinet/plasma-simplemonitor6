/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import QtQuick.Layouts

// Distribution name/version and kernel version below the logo.
Item {
    id: osInfo

    property string distroName: ""
    property string distroVersion: ""
    property string kernelName: ""
    property string kernelVersion: ""

    implicitWidth: infoColumn.implicitWidth
    implicitHeight: infoColumn.implicitHeight

    FontLoader {
        id: mondaRegular
        source: "../../fonts/Monda/Monda-Regular.ttf"
    }

    // "26.04.1 LTS (Resolute Raccoon)" -> two lines; "42.2, Leap" likewise.
    readonly property string distroText: {
        var v = distroVersion
        var cut = v.indexOf(" (")
        if (cut < 0)
            cut = v.indexOf(",")
        if (cut < 0)
            return (distroName + " " + v).trim()
        var rest = v.substring(cut + 1).replace(/^[\s,]+/, "").replace(/^\((.*)\)$/, "$1")
        return (distroName + " " + v.substring(0, cut)).trim() + "\n" + rest
    }

    ColumnLayout {
        id: infoColumn

        spacing: 1
        anchors.fill: parent

        Text {
            text: osInfo.distroText
            visible: text !== ""
            color: "white"
            lineHeight: 0.8
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            font { family: mondaRegular.name; pointSize: 9 }
        }

        Text {
            text: (osInfo.kernelName + " " + osInfo.kernelVersion).trim()
            color: "white"
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            font { family: mondaRegular.name; pointSize: 9 }
        }
    }
}
