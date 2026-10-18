/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

import "../../code/code.js" as Code

// One temperature line: label, value and a bar growing from the right.
Item {
    id: tempRow

    property string label: ""
    property real value: 0          // °C
    property int tempUnit: 0        // 0 = °C, 1 = °F
    property int highTemp: 70
    property int criticalTemp: 85
    property int maxTemp: criticalTemp
    property int indicatorHeight: 10
    property string fontFamily: ""

    implicitWidth: rowLabel.implicitWidth + valueLabel.implicitWidth + 8
    implicitHeight: rowLabel.implicitHeight + bar.height + 2

    Text {
        id: rowLabel
        anchors.left: parent.left
        text: tempRow.label
        font { family: tempRow.fontFamily; pointSize: 10; bold: true }
        color: "#ffdd55"
    }
    Text {
        id: valueLabel
        anchors.right: parent.right
        text: Code.formatTemp(tempRow.value, tempRow.tempUnit)
        font { pointSize: 10; bold: true }
        color: "white"
    }
    Rectangle {
        id: bar
        anchors.top: rowLabel.bottom
        anchors.topMargin: 1
        anchors.right: parent.right
        height: Math.max(2, Math.round(tempRow.indicatorHeight * 0.8))
        width: Math.floor(Math.min(1, Math.max(0, tempRow.value / Math.max(1, tempRow.maxTemp))) * parent.width)
        color: tempRow.value >= tempRow.criticalTemp ? "red"
             : tempRow.value >= tempRow.highTemp ? "#ffac2a"
             : "#85a9ff"
    }
}
