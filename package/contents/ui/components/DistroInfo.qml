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
import "../../code/code.js" as Code

// Logo plus distribution/kernel text, shared by all skins.
ColumnLayout {
    id: distroInfo

    property int logo: 0
    property string distroKey: ""
    property string systemLogoIcon: ""
    property real logoScale: 1.0
    property bool editMode: false

    property string distroName: ""
    property string distroVersion: ""
    property string kernelName: ""
    property string kernelVersion: ""

    signal logoScaleEdited(real newScale)

    spacing: 0

    LogoImage {
        id: distroLogo

        readonly property real ratio: implicitWidth > 0 ? implicitHeight / implicitWidth : 1

        logoKey: Code.logoKey(distroInfo.logo, distroInfo.distroKey)
        iconName: distroInfo.systemLogoIcon
        fillScale: distroInfo.logoScale
        editMode: distroInfo.editMode
        onScaleEdited: (newScale) => distroInfo.logoScaleEdited(newScale)

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter
        Layout.minimumWidth: 100
        Layout.preferredWidth: 100
        Layout.minimumHeight: 100 * ratio
        Layout.preferredHeight: width * ratio
    }

    OsInfoItem {
        distroName: distroInfo.distroName
        distroVersion: distroInfo.distroVersion
        kernelName: distroInfo.kernelName
        kernelVersion: distroInfo.kernelVersion

        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        Layout.topMargin: 2
        Layout.minimumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight
        Layout.maximumHeight: implicitHeight
    }
}
