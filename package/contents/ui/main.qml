/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 *
 * Entry point for Plasma 6. All logic lives in MonitorView.qml so that the
 * widget can also be loaded outside of Plasma (e.g. for screenshots/tests).
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    // Toggled from the widget's context menu; shows the resize handle on the logo.
    property bool logoEditMode: false

    preferredRepresentation: fullRepresentation

    Plasmoid.backgroundHints: {
        switch (Plasmoid.configuration.bgColor) {
        case 0:  return PlasmaCore.Types.StandardBackground
        case 2:  return PlasmaCore.Types.TranslucentBackground
        default: return PlasmaCore.Types.NoBackground
        }
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: root.logoEditMode ? i18n("Lock image scaling") : i18n("Unlock image scaling")
            icon.name: root.logoEditMode ? "object-locked" : "transform-scale"
            onTriggered: root.logoEditMode = !root.logoEditMode
        }
    ]

    fullRepresentation: MonitorView {
        cfg: Plasmoid.configuration
        logoEditMode: root.logoEditMode

        Layout.minimumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight
        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight
    }
}
