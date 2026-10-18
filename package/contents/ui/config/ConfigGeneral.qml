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
import org.kde.ksysguard.sensors as Sensors

import "../../code/code.js" as Code

KCM.SimpleKCM {
    id: page

    property alias cfg_logo: logoComboBox.currentIndex
    property int cfg_bgColor
    property alias cfg_showGpuTemp: showGpuTempCheckBox.checked
    property alias cfg_showSwap: showSwapCheckBox.checked
    property alias cfg_showUptime: showUptimeCheckBox.checked
    property int cfg_tempUnit
    property alias cfg_cpuTempMode: cpuTempModeComboBox.currentIndex
    property alias cfg_cpuHighTemp: cpuHighTempSpinBox.value
    property alias cfg_cpuCritTemp: cpuCritTempSpinBox.value

    // Used only for the logo preview ("Automatic").
    Sensors.Sensor { id: osNameSensor; sensorId: "os/system/name" }
    Sensors.Sensor { id: osLogoSensor; sensorId: "os/system/logo" }
    readonly property string detectedDistro:
        Code.detectDistro([String(osLogoSensor.value || ""), String(osNameSensor.value || "")])

    Kirigami.FormLayout {

        QQC2.ComboBox {
            id: logoComboBox
            Kirigami.FormData.label: i18n("Logo:")
            model: [i18n("Automatic"), i18n("Tux"), i18n("Slackware"), i18n("Ubuntu"), i18n("Kubuntu"),
                    i18n("OpenSUSE"), i18n("Manjaro"), i18n("Arch"), i18n("Fedora"), i18n("Debian")]
        }

        Image {
            readonly property string key: Code.logoKey(logoComboBox.currentIndex, page.detectedDistro)
            source: "../../images/distro-" + (key !== "" ? key : "tux") + ".svg"
            sourceSize.height: 100
            fillMode: Image.PreserveAspectFit
        }

        QQC2.Label {
            visible: logoComboBox.currentIndex === 0
            text: i18n("Automatic uses the logo of your distribution. If there is no matching built-in logo, the logo provided by the system is shown.")
            wrapMode: Text.WordWrap
            Layout.maximumWidth: Kirigami.Units.gridUnit * 20
            font: Kirigami.Theme.smallFont
            opacity: 0.8
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.ButtonGroup { id: bgGroup }

        QQC2.RadioButton {
            Kirigami.FormData.label: i18n("Background color:")
            QQC2.ButtonGroup.group: bgGroup
            text: i18n("Standard")
            checked: page.cfg_bgColor === 0
            onToggled: if (checked) page.cfg_bgColor = 0
        }
        QQC2.RadioButton {
            QQC2.ButtonGroup.group: bgGroup
            text: i18n("Crystal")
            checked: page.cfg_bgColor === 1
            onToggled: if (checked) page.cfg_bgColor = 1
        }
        QQC2.RadioButton {
            QQC2.ButtonGroup.group: bgGroup
            text: i18n("Translucent")
            checked: page.cfg_bgColor === 2
            onToggled: if (checked) page.cfg_bgColor = 2
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.CheckBox {
            id: showGpuTempCheckBox
            Kirigami.FormData.label: i18n("Show:")
            text: i18n("GPU Temperature")
        }
        QQC2.CheckBox {
            id: showSwapCheckBox
            text: i18n("Swap")
        }
        QQC2.CheckBox {
            id: showUptimeCheckBox
            text: i18n("Uptime")
        }

        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Temperature settings:")
        }

        QQC2.ButtonGroup { id: unitGroup }

        QQC2.RadioButton {
            Kirigami.FormData.label: i18n("Temperature units:")
            QQC2.ButtonGroup.group: unitGroup
            text: i18n("Celsius °C")
            checked: page.cfg_tempUnit === 0
            onToggled: if (checked) page.cfg_tempUnit = 0
        }
        QQC2.RadioButton {
            QQC2.ButtonGroup.group: unitGroup
            text: i18n("Fahrenheit °F")
            checked: page.cfg_tempUnit === 1
            onToggled: if (checked) page.cfg_tempUnit = 1
        }

        QQC2.ComboBox {
            id: cpuTempModeComboBox
            Kirigami.FormData.label: i18n("CPU temperature:")
            model: [i18n("Every core"), i18n("Average only"), i18n("Maximum only")]
        }

        QQC2.SpinBox {
            id: cpuHighTempSpinBox
            Kirigami.FormData.label: i18n("CPU High Temperature:")
            from: 20
            to: 150
            textFromValue: (value) => value + " °C"
            valueFromText: (text) => parseInt(text)
        }

        QQC2.SpinBox {
            id: cpuCritTempSpinBox
            Kirigami.FormData.label: i18n("CPU Critical Temperature:")
            from: 20
            to: 150
            textFromValue: (value) => value + " °C"
            valueFromText: (text) => parseInt(text)
        }

        QQC2.Label {
            text: i18n("Thresholds are always given in °C. The command <b>sensors</b> shows the limits of your hardware (\"high\" and \"crit\").")
            textFormat: Text.StyledText
            wrapMode: Text.WordWrap
            Layout.maximumWidth: Kirigami.Units.gridUnit * 20
            font: Kirigami.Theme.smallFont
            opacity: 0.8
        }
    }
}
