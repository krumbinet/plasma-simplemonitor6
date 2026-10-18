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
        Layout.rightMargin: 5
    }

    RowLayout {
        id: mainLayout

        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        ColumnLayout {
            spacing: 0

            Layout.topMargin: 5
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

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

                Layout.fillWidth: true
            }

            UptimePicker {
                visible: root.showUptime
                uptime: root.uptime

                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 6
            }

            Item { Layout.fillHeight: true }
        }

        // Vertical separator
        Rectangle {
            color: "white"

            Layout.minimumWidth: 3
            Layout.maximumWidth: 3
            Layout.preferredWidth: 3
            Layout.fillHeight: true
            Layout.topMargin: 5
        }

        ColumnLayout {
            spacing: 0

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            AverageCPU {
                avgLoad: sysData.cpuAvgLoad
                avgTemp: sysData.cpuAvgTemp
                tempUnit: root.tempUnit
                highTemp: root.cpuHighTemp
                criticalTemp: root.cpuCritTemp

                Layout.topMargin: 2
                Layout.leftMargin: 10
                Layout.rightMargin: 5
                Layout.fillWidth: true
                Layout.minimumWidth: implicitWidth
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight
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
}
