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

    property alias cfg_coloredCpuLoad: coloredCpuLoadCheckBox.checked
    property alias cfg_flatCpuLoad: flatCpuLoadCheckBox.checked
    property alias cfg_indicatorHeight: indicatorHeightSpinBox.value
    property real cfg_updateInterval: 1.0

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: coloredCpuLoadCheckBox
            Kirigami.FormData.label: i18n("CPU load indicator style:")
            text: i18n("Colored")
        }
        QQC2.CheckBox {
            id: flatCpuLoadCheckBox
            text: i18n("Flat")
        }

        QQC2.SpinBox {
            id: indicatorHeightSpinBox
            Kirigami.FormData.label: i18n("CPU load indicator height:")
            from: 1
            to: 99
        }

        Item { Kirigami.FormData.isSection: true }

        // Tenths of a second, so that the integer SpinBox can show 0.5 s etc.
        QQC2.SpinBox {
            id: updateIntervalSpinBox
            Kirigami.FormData.label: i18n("Update interval:")
            from: 1
            to: 100
            stepSize: 1
            value: Math.round(page.cfg_updateInterval * 10)
            onValueModified: page.cfg_updateInterval = value / 10
            textFromValue: (value, locale) => Number(value / 10).toLocaleString(locale, "f", 1) + " " + i18nc("Abbreviation for seconds", "s")
            valueFromText: (text, locale) => Math.round(Number.fromLocaleString(locale, text.replace(/[^0-9.,]/g, "")) * 10)
        }
    }
}
