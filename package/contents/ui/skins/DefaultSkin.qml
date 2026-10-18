/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import QtQuick.Layouts

import "../monitorWidgets"
import "../components"

BaseSkin {
    id: root

    implicitWidth: mainLayout.implicitWidth + 2 * mainLayout.anchors.margins
    implicitHeight: mainLayout.implicitHeight + 2 * mainLayout.anchors.margins

    component HLine: Rectangle {
        color: "white"
        Layout.fillWidth: true
        Layout.minimumHeight: 3
        Layout.maximumHeight: 3
        Layout.preferredHeight: 3
    }

    GridLayout {
        id: mainLayout

        anchors.fill: parent
        anchors.margins: 5
        columns: 4
        columnSpacing: 0
        rowSpacing: 0

        // Row 0: date
        DatePicker {
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 4
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 10
        }

        // Rows 1-3, column 0: logo and system info
        DistroInfo {
            logo: root.logo
            distroKey: root.distroKey
            systemLogoIcon: sysData.osLogo
            logoScale: confEngine.logoScale
            editMode: confEngine.logoEditMode
            onLogoScaleEdited: (newScale) => confEngine.setLogoScale(newScale)

            distroName: root.distroName
            distroVersion: root.distroVersion
            kernelName: root.kernelName
            kernelVersion: root.kernelVersion

            Layout.row: 1
            Layout.column: 0
            Layout.rowSpan: 3
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
        }

        // Row 1: clock and uptime
        TimePicker {
            Layout.row: 1
            Layout.column: 1
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.leftMargin: 10
            Layout.bottomMargin: 5
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
        }

        UptimePicker {
            visible: root.showUptime
            uptime: root.uptime

            Layout.row: 1
            Layout.column: 3
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom
            Layout.bottomMargin: 2
        }

        // Row 2: separator
        HLine {
            Layout.row: 2
            Layout.column: 1
            Layout.columnSpan: 3
            Layout.leftMargin: 2
        }

        // Row 3, column 1: temperatures
        ColumnLayout {
            spacing: 1

            Layout.row: 3
            Layout.column: 1
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            CoreTempList {
                model: sysData.coreTempModel
                mode: root.cpuTempMode
                avgTemp: sysData.cpuAvgTemp
                maxTemp: sysData.cpuMaxTemp
                highTemp: root.cpuHighTemp
                criticalTemp: root.cpuCritTemp
                tempUnit: root.tempUnit
                indicatorHeight: root.indicatorHeight
                direction: root.direction

                Layout.fillWidth: true
                Layout.minimumWidth: Math.max(100, implicitWidth)
            }

            GpuTempList {
                visible: root.showGpuTemp
                model: sysData.gpuTempModel
                highTemp: root.cpuHighTemp
                criticalTemp: root.cpuCritTemp
                tempUnit: root.tempUnit
                indicatorHeight: root.indicatorHeight
                direction: root.direction

                Layout.fillWidth: true
                Layout.minimumWidth: Math.max(100, implicitWidth)
            }

            Item { Layout.fillHeight: true }
        }

        // Rows 3-7, column 2: vertical separator
        Rectangle {
            color: "white"

            Layout.row: 3
            Layout.column: 2
            Layout.rowSpan: 5
            Layout.minimumWidth: 3
            Layout.maximumWidth: 3
            Layout.preferredWidth: 3
            Layout.fillHeight: true
            Layout.topMargin: 5
        }

        // Rows 3-7, column 3: CPU load
        CpuWidget {
            model: sysData.cpuModel
            flatCpuLoad: root.flatCpuLoad
            coloredCpuLoad: root.coloredCpuLoad
            indicatorHeight: root.indicatorHeight
            direction: root.direction

            Layout.row: 3
            Layout.column: 3
            Layout.rowSpan: 5
            Layout.leftMargin: 5
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
        }

        // Rows 4-7, columns 0-1: memory and swap
        HLine {
            Layout.row: 4
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.topMargin: 5
            Layout.rightMargin: 5
        }

        MemArea {
            memTotal: root.memTotal
            memUsed: root.memUsed
            memFree: root.memFree

            Layout.row: 5
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
        }

        HLine {
            visible: root.showSwap
            Layout.row: 6
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.topMargin: 5
            Layout.rightMargin: 5
        }

        MemArea {
            visible: root.showSwap
            memTypeLabel: i18n("Swap:")
            memTotal: root.swapTotal
            memUsed: root.swapUsed
            memFree: root.swapFree

            Layout.row: 7
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
        }
    }
}
