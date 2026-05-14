import QtQuick

Rectangle {
    id: root

    required property string label
    property bool active: true
    signal clicked

    Theme {
        id: theme
    }

    width: theme.controlSize
    height: theme.controlSize
    radius: 999
    color: mouse.containsMouse ? theme.hoverBg : theme.chipBg
    opacity: active ? 1.0 : 0.45

    Text {
        anchors.centerIn: parent
        color: theme.text
        text: root.label
        font.pixelSize: 14
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.active
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
