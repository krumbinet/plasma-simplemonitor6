/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 *
 * The visible widget: reads the configuration, owns the sensor data and
 * loads the selected skin. Skins access "confEngine" and "sysData" by id.
 */

import QtQuick

import "../code/code.js" as Code

Rectangle {
    id: monitorView

    // Plasmoid.configuration (or a plain object with the same keys in tests).
    property var cfg
    property bool logoEditMode: false

    implicitWidth: loader.item ? loader.item.implicitWidth : 0
    implicitHeight: loader.item ? loader.item.implicitHeight : 0

    color: confEngine.bgColor === 0 ? "black" : "transparent"

    QtObject {
        id: confEngine

        // Configuration properties.
        readonly property int skin:              Code.num(cfg.skin, 0)
        readonly property int bgColor:           Code.num(cfg.bgColor, 1)
        readonly property int logo:              Code.num(cfg.logo, 0)
        readonly property real logoScale:        Code.num(cfg.logoScale, 1.0)
        readonly property bool showGpuTemp:      !!cfg.showGpuTemp
        readonly property bool showSwap:         !!cfg.showSwap
        readonly property bool showUptime:       !!cfg.showUptime
        readonly property int tempUnit:          Code.num(cfg.tempUnit, 0)
        readonly property int cpuTempMode:       Code.num(cfg.cpuTempMode, 0)
        readonly property int cpuHighTemp:       Code.num(cfg.cpuHighTemp, 70)
        readonly property int cpuCritTemp:       Code.num(cfg.cpuCritTemp, 85)
        readonly property bool coloredCpuLoad:   !!cfg.coloredCpuLoad
        readonly property bool flatCpuLoad:      !!cfg.flatCpuLoad
        readonly property int indicatorHeight:   Code.num(cfg.indicatorHeight, 10)
        readonly property real updateInterval:   Math.max(0.1, Code.num(cfg.updateInterval, 1.0))

        readonly property bool logoEditMode:     monitorView.logoEditMode

        readonly property int direction: Qt.application.layoutDirection

        function setLogoScale(value) {
            if (cfg.logoScale !== value)
                cfg.logoScale = value
        }
    }

    SystemData {
        id: sysData
        updateInterval: confEngine.updateInterval
        perCoreTemps: confEngine.cpuTempMode === 0
        gpuEnabled: confEngine.showGpuTemp
    }

    Loader {
        id: loader
        anchors.fill: parent
        source: {
            switch (confEngine.skin) {
            case 1:  return "skins/ColumnSkin.qml"
            case 2:  return "skins/MinimalisticSkin.qml"
            default: return "skins/DefaultSkin.qml"
            }
        }
    }
}
