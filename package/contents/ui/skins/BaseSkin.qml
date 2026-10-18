/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

import QtQuick

Item {
    property int bgColor:           confEngine.bgColor
    property int logo:              confEngine.logo
    property bool showGpuTemp:      confEngine.showGpuTemp
    property bool showSwap:         confEngine.showSwap
    property bool showUptime:       confEngine.showUptime
    property int tempUnit:          confEngine.tempUnit
    property int cpuTempMode:       confEngine.cpuTempMode
    property int cpuHighTemp:       confEngine.cpuHighTemp
    property int cpuCritTemp:       confEngine.cpuCritTemp
    property bool coloredCpuLoad:   confEngine.coloredCpuLoad
    property bool flatCpuLoad:      confEngine.flatCpuLoad
    property int indicatorHeight:   confEngine.indicatorHeight
    property real updateInterval:   confEngine.updateInterval

    property string distroKey:      sysData.distroKey
    property string distroName:     sysData.osName
    property string distroVersion:  sysData.osVersion
    property string kernelName:     sysData.kernelName
    property string kernelVersion:  sysData.kernelVersion

    property real memFree:   sysData.memFree
    property real memTotal:  sysData.memTotal
    property real memUsed:   sysData.memUsed

    property real swapFree:  sysData.swapFree
    property real swapTotal: sysData.swapTotal
    property real swapUsed:  sysData.swapUsed

    property int uptime: sysData.uptime

    property int direction: confEngine.direction
    LayoutMirroring.enabled: direction === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
}
