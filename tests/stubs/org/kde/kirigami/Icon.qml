import QtQuick
Item {
    property var source
    property var fallback
    Image { anchors.fill: parent; fillMode: Image.PreserveAspectFit; source: parent.fallback || "" }
    Rectangle { anchors.fill: parent; color: "transparent"; border.color: "magenta" }
}
