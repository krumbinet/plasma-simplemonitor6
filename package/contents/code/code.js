/*
 * SPDX-FileCopyrightText: 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 * SPDX-FileCopyrightText: 2026 krumbinet and Simple Monitor Plasma 6 port contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This file is part of plasma-simpleMonitor.
 */

.pragma library

// Order must match the "logo" choices in config/main.xml (index - 1).
var logos = ["tux", "slackware", "ubuntu", "kubuntu", "opensuse", "manjaro", "arch", "fedora", "debian"]

// Maps distribution names / os-release IDs / logo icon names to our bundled logos.
var aliases = {
    "tux": "tux",
    "linux": "tux",
    "slackware": "slackware",
    "ubuntu": "ubuntu",
    "kubuntu": "kubuntu",
    "neon": "kubuntu",
    "opensuse": "opensuse",
    "opensuse-tumbleweed": "opensuse",
    "opensuse-leap": "opensuse",
    "suse": "opensuse",
    "manjaro": "manjaro",
    "arch": "arch",
    "archlinux": "arch",
    "endeavouros": "arch",
    "fedora": "fedora",
    "debian": "debian"
}

/**
 * Tries to find a bundled logo for the running distribution.
 * candidates: strings such as the OS name ("Ubuntu"), the pretty name or
 * the LOGO icon name from os-release ("distributor-logo-fedora").
 * Returns the logo key (e.g. "ubuntu") or "" if nothing matched.
 */
function detectDistro(candidates) {
    for (var i = 0; i < candidates.length; ++i) {
        var c = String(candidates[i] || "").toLowerCase().trim()
        if (c === "")
            continue
        if (aliases.hasOwnProperty(c))
            return aliases[c]
        // "distributor-logo-fedora", "ubuntu-logo", "Kubuntu 26.04 LTS", ...
        var words = c.split(/[^a-z]+/)
        for (var w = 0; w < words.length; ++w) {
            if (words[w] !== "logo" && words[w] !== "distributor" && aliases.hasOwnProperty(words[w]))
                return aliases[words[w]]
        }
    }
    return ""
}

/**
 * logoId: configured logo (0 = automatic, 1.. = fixed logo, see main.xml)
 * distroKey: result of detectDistro()
 * Returns the key of a bundled logo (images/distro-<key>.svg) or "" if none
 * fits (the caller then falls back to the system's own logo icon or Tux).
 */
function logoKey(logoId, distroKey) {
    if (logoId > 0 && logoId <= logos.length)
        return logos[logoId - 1]
    if (distroKey && logos.indexOf(distroKey) !== -1)
        return distroKey
    return ""
}

/** Shortens "7.0.0-38-generic" to "7.0.0". */
function shortKernelVersion(version) {
    var v = String(version || "")
    var dash = v.indexOf('-')
    return dash > 0 ? v.substring(0, dash) : v
}

function toFahrenheit(celsius) {
    return celsius * 9 / 5 + 32
}

/** Formats a temperature given in °C according to the unit setting (0 = °C, 1 = °F). */
function formatTemp(celsius, tempUnit) {
    if (isNaN(celsius))
        return "–"
    return tempUnit === 1 ? Math.round(toFahrenheit(celsius)) + "°F"
                          : Math.round(celsius) + "°C"
}

var GiB = 1024 * 1024 * 1024

function toGiB(bytes) {
    var n = Number(bytes)
    return isNaN(n) ? 0 : n / GiB
}

/** Number() that maps undefined/NaN to a fallback. */
function num(value, fallback) {
    var n = Number(value)
    return (value === undefined || value === null || isNaN(n)) ? fallback : n
}
