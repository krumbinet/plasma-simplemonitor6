/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: page

    property alias cfg_skin: skinComboBox.currentIndex

    readonly property var previews: ["defaultSkin-preview.png", "columnSkin-preview.png", "minimalisticSkin-preview.png"]

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: skinComboBox
            Kirigami.FormData.label: i18n("Skin:")
            model: [i18n("Default"), i18n("Column"), i18n("Minimalistic")]
        }

        Image {
            Kirigami.FormData.label: i18n("Preview:")
            source: "../../images/" + page.previews[Math.max(0, Math.min(2, skinComboBox.currentIndex))]
            fillMode: Image.PreserveAspectFit
            Layout.maximumWidth: Kirigami.Units.gridUnit * 18
            Layout.maximumHeight: Kirigami.Units.gridUnit * 26
        }
    }
}
