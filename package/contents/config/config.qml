/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: Qt.resolvedUrl("../images/simpleMonitor.svg")
        source: "config/ConfigGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Skins")
        icon: Qt.resolvedUrl("../images/simpleMonitor-skins.svg")
        source: "config/ConfigSkins.qml"
    }
    ConfigCategory {
        name: i18n("Miscellaneous")
        icon: "preferences-system-other"
        source: "config/ConfigMisc.qml"
    }
}
