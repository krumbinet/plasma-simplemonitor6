/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

Row {
    id: uptimePicker

    property int uptime: 0

    spacing: 3

    readonly property int days: Math.floor(uptime / 86400)
    readonly property int hours: Math.floor((uptime % 86400) / 3600)
    readonly property int minutes: Math.floor((uptime % 3600) / 60)

    Text {
        text: i18n("Uptime:")
        color: "#b3b3b3"
    }

    Text {
        text: i18n("%1d %2:%3", uptimePicker.days, uptimePicker.hours,
                   ((uptimePicker.minutes < 10) ? "0" : "") + uptimePicker.minutes)
        color: "white"
    }
}
