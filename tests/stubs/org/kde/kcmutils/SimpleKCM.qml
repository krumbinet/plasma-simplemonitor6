import QtQuick
Rectangle { color: "#eff0f1"; default property alias content: holder.data; Item { id: holder; x: 10; y: 10; width: parent.width-20; height: parent.height-20 } }
