/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

// Load bars for every logical CPU.
ListView {
    id: cpuListView

    property int direction: Qt.LeftToRight
    LayoutMirroring.enabled: direction === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property bool flatCpuLoad: true
    property bool coloredCpuLoad: true
    property int indicatorHeight: 10

    implicitWidth: 100
    implicitHeight: contentHeight

    interactive: false
    spacing: 1

    FontLoader {
        id: doppioOneRegular
        source: "../../fonts/Doppio_One/DoppioOne-Regular.ttf"
    }

    delegate: Item {
        id: itemElement

        required property int index
        required property real val

        width: cpuListView.width
        height: cpuListItem.implicitHeight

        Column {
            id: cpuListItem
            width: parent.width
            spacing: 1

            Item {
                width: parent.width
                implicitHeight: Math.max(cpuLabel.implicitHeight, cpuText.implicitHeight)

                Text {
                    id: cpuLabel
                    anchors.left: parent.left
                    text: i18n("CPU %1:", itemElement.index)
                    font { family: doppioOneRegular.name; pointSize: 10; bold: true }
                    color: "#ffdd55"
                }
                Text {
                    id: cpuText
                    anchors.left: cpuLabel.right
                    text: Math.floor(itemElement.val) + "%"
                    font { pointSize: 10; bold: true }
                    color: "white"
                }
            }

            Item {
                id: progressBar
                height: cpuListView.indicatorHeight
                width: parent.width

                Rectangle {
                    // Clear background (3D style only).
                    anchors.fill: parent
                    visible: !cpuListView.flatCpuLoad
                    radius: 2
                    gradient: Gradient {
                        GradientStop { position: 0.00; color: "#99000000" }
                        GradientStop { position: 0.25; color: "#55555555" }
                        GradientStop { position: 1.00; color: "transparent" }
                    }
                    border.color: "#33ffffff"
                }

                Rectangle {
                    id: rectValue
                    // Visible part of the bar; the full-width gradient below is clipped,
                    // so the colour shows how high the load is.
                    anchors.left: parent.left
                    height: parent.height
                    color: "transparent"
                    clip: true
                    border.color: "#33ffffff"
                    width: Math.min(1, Math.max(0, itemElement.val / 100))
                           * (cpuListView.flatCpuLoad ? parent.width : parent.width - 5)

                    Rectangle {
                        anchors.left: parent.left
                        height: progressBar.height
                        width: progressBar.width
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.00; color: cpuListView.coloredCpuLoad ? "#7ec264" : "#4dffffff" }
                            GradientStop { position: 0.40; color: cpuListView.coloredCpuLoad ? "#7ec264" : "#6a9cf28a" }
                            GradientStop { position: 0.65; color: cpuListView.coloredCpuLoad ? "#ffdd55" : "#7f7ce86f" }
                            GradientStop { position: 0.90; color: cpuListView.coloredCpuLoad ? "red"     : "#8c50e52c" }
                            GradientStop { position: 1.00; color: cpuListView.coloredCpuLoad ? "red"     : "#993de515" }
                        }
                    }
                    Rectangle {
                        // Shadow (3D style only).
                        anchors.left: parent.left
                        height: progressBar.height
                        width: progressBar.width
                        visible: !cpuListView.flatCpuLoad
                        gradient: Gradient {
                            GradientStop { position: 0.00; color: "#99000000" }
                            GradientStop { position: 0.25; color: "#55555555" }
                            GradientStop { position: 0.88; color: "transparent" }
                            GradientStop { position: 1.00; color: "#eeffffff" }
                        }
                    }
                }
                Rectangle {
                    // Slider knob (3D style only).
                    height: progressBar.height + 4
                    width: 5
                    radius: 2
                    anchors.left: rectValue.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#88ffffff"
                    visible: !cpuListView.flatCpuLoad
                }
            }
        }
    }
}
