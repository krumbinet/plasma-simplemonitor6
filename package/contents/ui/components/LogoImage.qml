/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import org.kde.kirigami as Kirigami

// Distribution logo. Uses a bundled SVG when one matches, otherwise the
// logo icon the distribution itself ships (os-release LOGO=), otherwise Tux.
// In edit mode a handle in the top right corner scales the logo.
Item {
    id: logoRoot

    property string logoKey: ""      // bundled logo (images/distro-<key>.svg), may be empty
    property string iconName: ""     // system logo icon name, may be empty
    property real fillScale: 1.0
    property bool editMode: false

    signal scaleEdited(real newScale)

    readonly property bool useIcon: logoKey === "" && iconName !== ""
    readonly property real scaleFactor: (fillScale > 0 && fillScale <= 1.0) ? fillScale : 1.0

    implicitWidth: useIcon ? 128 : image.implicitWidth
    implicitHeight: useIcon ? 128 : image.implicitHeight

    Image {
        id: image
        anchors.centerIn: parent
        visible: !logoRoot.useIcon
        width: parent.width * logoRoot.scaleFactor
        height: parent.height * logoRoot.scaleFactor
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(512, 512)
        source: "../../images/distro-" + (logoRoot.logoKey !== "" ? logoRoot.logoKey : "tux") + ".svg"
    }

    Kirigami.Icon {
        id: icon
        anchors.centerIn: parent
        visible: logoRoot.useIcon
        width: parent.width * logoRoot.scaleFactor
        height: parent.height * logoRoot.scaleFactor
        source: logoRoot.iconName
        // Fall back to Tux if the theme does not have the icon.
        fallback: Qt.resolvedUrl("../../images/distro-tux.svg")
    }

    Rectangle {
        id: frame
        anchors.centerIn: parent
        width: parent.width * logoRoot.scaleFactor
        height: parent.height * logoRoot.scaleFactor
        visible: logoRoot.editMode
        border { width: 1; color: "black" }
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            border { width: 1; color: "white" }
            color: "transparent"
        }

        Image {
            anchors {
                right: parent.right
                top: parent.top
            }
            source: "../../images/resize.svg"
            sourceSize: Qt.size(12, 12)

            MouseArea {
                id: resizeArea
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: pressed ? Qt.SizeBDiagCursor : Qt.ArrowCursor

                onPositionChanged: (mouse) => {
                    if (!pressed)
                        return
                    var p = mapToItem(logoRoot, mouse.x, mouse.y)
                    var s = Math.max(2 * p.x / logoRoot.width - 1.0, 1.0 - 2 * p.y / logoRoot.height)
                    logoRoot.scaleEdited(Math.min(Math.max(0.3, s), 1.0))
                }
            }
        }
    }
}
