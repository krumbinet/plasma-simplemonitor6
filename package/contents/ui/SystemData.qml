/*
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 *
 * Collects all values from the Plasma 6 sensor system (ksystemstats via
 * org.kde.ksysguard.sensors). This replaces the "systemmonitor" data engine
 * of Plasma 5 (ksysguardd), which no longer exists.
 *
 * Nothing here is tied to specific hardware: ksystemstats already maps
 * coretemp, k10temp, zenpower, amdgpu, nvidia, ... onto generic sensor IDs.
 * Sensors that do not exist on a machine are simply not shown.
 */

import QtQuick
import org.kde.ksysguard.sensors as Sensors

import "../code/code.js" as Code

Item {
    id: sysData

    visible: false

    property real updateInterval: 1.0
    readonly property int rate: Math.round(updateInterval * 1000)

    // When false, the per-core temperature sensors are not subscribed at all.
    property bool perCoreTemps: true
    property bool gpuEnabled: true

    // Highest GPU index probed (gpu/gpu0 ... gpu/gpuN).
    readonly property int maxGpus: 8

    // ---- Models used by the widgets ---------------------------------------
    // cpuModel:      { val }              load per logical CPU in %
    // coreTempModel: { val, avail }       temperature per logical CPU in °C
    // gpuTempModel:  { val, avail, gpuLabel } temperature per GPU in °C
    readonly property alias cpuModel: cpuModel
    readonly property alias coreTempModel: coreTempModel
    readonly property alias gpuTempModel: gpuTempModel

    readonly property int cpuCount: Math.max(0, Math.round(Code.num(coreCountSensor.value, 0)))

    // ---- Simple values ----------------------------------------------------
    readonly property real cpuAvgLoad: Code.num(cpuAllUsage.value, 0)
    readonly property real cpuAvgTemp: Code.num(cpuAvgTempSensor.value, NaN)
    readonly property real cpuMaxTemp: Code.num(cpuMaxTempSensor.value, NaN)

    // Memory in GiB. "application" is what the old widget showed as used
    // (used minus buffers and cache).
    readonly property real memTotal: Code.toGiB(memTotalSensor.value)
    readonly property real memUsed:  Code.toGiB(memAppSensor.value)
    readonly property real memFree:  Math.max(0, memTotal - memUsed)

    readonly property real swapTotal: Code.toGiB(swapTotalSensor.value)
    readonly property real swapUsed:  Code.toGiB(swapUsedSensor.value)
    readonly property real swapFree:  Math.max(0, swapTotal - swapUsed)

    readonly property int uptime: Math.round(Code.num(uptimeSensor.value, 0))

    readonly property string osName:       String(osNameSensor.value || "")
    readonly property string osVersion:    String(osVersionSensor.value || "")
    readonly property string osPrettyName: String(osPrettyNameSensor.value || "")
    readonly property string osLogo:       String(osLogoSensor.value || "")
    readonly property string kernelName:   String(kernelNameSensor.value || "Linux")
    readonly property string kernelVersion: Code.shortKernelVersion(kernelVersionSensor.value)

    // Bundled logo matching the running distribution, "" if none fits.
    readonly property string distroKey: Code.detectDistro([osLogo, osName, osPrettyName])

    // ---- Models -------------------------------------------------------------
    ListModel { id: cpuModel }
    ListModel { id: coreTempModel }
    ListModel { id: gpuTempModel }

    function resize(model, count, row) {
        while (model.count > count)
            model.remove(model.count - 1)
        while (model.count < count)
            model.append(row)
    }

    // Keeps the model sizes in sync with the number of CPUs / GPU slots.
    // Called before every model update because sensors may report before
    // this item has finished loading.
    function ensureRows() {
        if (cpuModel.count !== cpuCount)
            resize(cpuModel, cpuCount, { "val": 0.0 })
        if (coreTempModel.count !== cpuCount)
            resize(coreTempModel, cpuCount, { "val": 0.0, "avail": false })
        if (gpuTempModel.count !== maxGpus)
            resize(gpuTempModel, maxGpus, { "val": 0.0, "avail": false, "gpuLabel": "" })
    }

    onCpuCountChanged: ensureRows()
    Component.onCompleted: ensureRows()

    // Number of GPUs that actually deliver a temperature.
    property int gpuCount: 0
    function updateGpuLabels() {
        var found = []
        for (var i = 0; i < gpuTempModel.count; ++i)
            if (gpuTempModel.get(i).avail)
                found.push(i)
        gpuCount = found.length
        for (var n = 0; n < found.length; ++n)
            gpuTempModel.setProperty(found[n], "gpuLabel",
                                     found.length === 1 ? i18n("GPU:") : i18n("GPU %1:", n))
    }

    // ---- Sensors --------------------------------------------------------------
    // Note: inline components do not see ids of this file, so the rate limit
    // is set at every use site.
    component Sens: Sensors.Sensor {}

    Sens { id: coreCountSensor; sensorId: "cpu/all/coreCount"; updateRateLimit: sysData.rate }
    Sens { id: cpuAllUsage; sensorId: "cpu/all/usage"; updateRateLimit: sysData.rate }
    Sens { id: cpuAvgTempSensor; sensorId: "cpu/all/averageTemperature"; updateRateLimit: sysData.rate }
    Sens { id: cpuMaxTempSensor; sensorId: "cpu/all/maximumTemperature"; updateRateLimit: sysData.rate }

    Sens { id: memTotalSensor; sensorId: "memory/physical/total"; updateRateLimit: sysData.rate }
    Sens { id: memAppSensor; sensorId: "memory/physical/application"; updateRateLimit: sysData.rate }
    Sens { id: swapTotalSensor; sensorId: "memory/swap/total"; updateRateLimit: sysData.rate }
    Sens { id: swapUsedSensor; sensorId: "memory/swap/used"; updateRateLimit: sysData.rate }

    Sens { id: uptimeSensor; sensorId: "os/system/uptime"; updateRateLimit: sysData.rate }

    Sens { id: osNameSensor; sensorId: "os/system/name"; updateRateLimit: sysData.rate }
    Sens { id: osVersionSensor; sensorId: "os/system/version"; updateRateLimit: sysData.rate }
    Sens { id: osPrettyNameSensor; sensorId: "os/system/prettyName"; updateRateLimit: sysData.rate }
    Sens { id: osLogoSensor; sensorId: "os/system/logo"; updateRateLimit: sysData.rate }
    Sens { id: kernelNameSensor; sensorId: "os/kernel/name"; updateRateLimit: sysData.rate }
    Sens { id: kernelVersionSensor; sensorId: "os/kernel/version"; updateRateLimit: sysData.rate }

    // Load per logical CPU.
    Instantiator {
        model: sysData.cpuCount
        delegate: Sens {
            required property int index
            updateRateLimit: sysData.rate
            sensorId: "cpu/cpu" + index + "/usage"
            function apply() {
                sysData.ensureRows()
                if (index < cpuModel.count)
                    cpuModel.setProperty(index, "val", Code.num(value, 0))
            }
            onValueChanged: apply()
            Component.onCompleted: apply()
        }
    }

    // Temperature per logical CPU (only subscribed when shown).
    Instantiator {
        model: sysData.perCoreTemps ? sysData.cpuCount : 0
        delegate: Sens {
            required property int index
            updateRateLimit: sysData.rate
            sensorId: "cpu/cpu" + index + "/temperature"
            function apply() {
                sysData.ensureRows()
                if (index >= coreTempModel.count)
                    return
                var v = Code.num(value, NaN)
                coreTempModel.setProperty(index, "avail", !isNaN(v))
                coreTempModel.setProperty(index, "val", isNaN(v) ? 0.0 : v)
            }
            onValueChanged: apply()
            Component.onCompleted: apply()
        }
    }

    // Temperature per GPU. ksystemstats numbers GPUs by their DRM card, so
    // the indices may have gaps (e.g. only gpu/gpu1 on a single NVIDIA card).
    Instantiator {
        model: sysData.gpuEnabled ? sysData.maxGpus : 0
        delegate: Sens {
            required property int index
            updateRateLimit: sysData.rate
            sensorId: "gpu/gpu" + index + "/temperature"
            onValueChanged: apply()
            Component.onCompleted: apply()
            function apply() {
                sysData.ensureRows()
                if (index >= gpuTempModel.count)
                    return
                var v = Code.num(value, NaN)
                var wasAvail = gpuTempModel.get(index).avail
                gpuTempModel.setProperty(index, "avail", !isNaN(v))
                gpuTempModel.setProperty(index, "val", isNaN(v) ? 0.0 : v)
                if (wasAvail !== !isNaN(v))
                    sysData.updateGpuLabels()
            }
        }
    }
}
