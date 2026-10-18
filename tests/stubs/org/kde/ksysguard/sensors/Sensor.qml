import QtQuick
// Test double for org.kde.ksysguard.sensors.Sensor with fixed fake values.
QtObject {
    property string sensorId
    property int updateRateLimit
    property var value: fake(sensorId)
    function fake(id) {
        var t = {
            "cpu/all/coreCount": FAKE_CORES, "cpu/all/usage": 23.4,
            "cpu/all/averageTemperature": 47.2, "cpu/all/maximumTemperature": 74,
            "memory/physical/total": 32*1073741824, "memory/physical/application": 9.31*1073741824,
            "memory/swap/total": 8*1073741824, "memory/swap/used": 0.42*1073741824,
            "os/system/uptime": 2*86400 + 3*3600 + 7*60,
            "os/system/name": "FAKE_OSNAME", "os/system/version": "26.04.1 LTS (Resolute Raccoon)",
            "os/system/prettyName": "FAKE_OSNAME 26.04.1 LTS", "os/system/logo": "FAKE_LOGO",
            "os/kernel/name": "Linux", "os/kernel/version": "7.0.0-38-generic",
            "gpu/gpu1/temperature": 39
        }
        if (t.hasOwnProperty(id)) return t[id]
        var m = id.match(/^cpu\/cpu(\d+)\/(usage|temperature)$/)
        if (m) { var i = parseInt(m[1]); return m[2] === "usage" ? [3, 18, 47, 66, 81, 95, 12, 30, 55, 7, 99, 40, 22, 61, 74, 5][i % 16] : [33, 32, 48, 72, 30, 88, 34, 35][i % 8] }
        return undefined
    }
}
