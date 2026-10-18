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
        Layout.topMargin: 5
    }

    ColumnLayout {
        id: mainLayout

        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        // Date with uptime in the top right corner
        Item {
            implicitHeight: datePicker.implicitHeight
            implicitWidth: datePicker.implicitWidth + 10 + (uptimePicker.visible ? uptimePicker.implicitWidth : 0)

            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.minimumWidth: implicitWidth

            DatePicker {
                id: datePicker
                anchors { left: parent.left; leftMargin: 10 }
            }

            UptimePicker {
                id: uptimePicker
                anchors { top: parent.top; right: parent.right }
                visible: root.showUptime
                uptime: root.uptime
            }
        }

        GridLayout {
            columns: 2
            columnSpacing: 0
            rowSpacing: 0

            Layout.fillWidth: true
            Layout.topMargin: 5

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

                Layout.row: 0
                Layout.column: 0
                Layout.rowSpan: 3
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop
            }

            TimePicker {
                Layout.row: 0
                Layout.column: 1
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 10
                Layout.bottomMargin: 5
                Layout.minimumWidth: implicitWidth
                Layout.minimumHeight: implicitHeight
            }

            Rectangle {
                color: "white"

                Layout.row: 1
                Layout.column: 1
                Layout.leftMargin: 2
                Layout.fillWidth: true
                Layout.minimumHeight: 3
                Layout.maximumHeight: 3
                Layout.preferredHeight: 3
            }

            ColumnLayout {
                spacing: 1

                Layout.row: 2
                Layout.column: 1
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Layout.topMargin: 5
                Layout.fillWidth: true
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
            }
        }

        HLine {}

        CpuWidget {
            model: sysData.cpuModel
            flatCpuLoad: root.flatCpuLoad
            coloredCpuLoad: root.coloredCpuLoad
            indicatorHeight: root.indicatorHeight
            direction: root.direction

            Layout.leftMargin: 5
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
            Layout.preferredHeight: implicitHeight
        }

        HLine {}

        MemArea {
            memTotal: root.memTotal
            memUsed: root.memUsed
            memFree: root.memFree

            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
        }

        HLine { visible: root.showSwap }

        MemArea {
            visible: root.showSwap
            memTypeLabel: i18n("Swap:")
            memTotal: root.swapTotal
            memUsed: root.swapUsed
            memFree: root.swapFree

            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.minimumWidth: implicitWidth
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
        }

        Item { Layout.fillHeight: true }
    }
}
