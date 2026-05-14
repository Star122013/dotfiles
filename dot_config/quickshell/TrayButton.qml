import QtQuick
import Quickshell.Services.SystemTray

Rectangle {
    id: root

    required property var item
    required property var panelWindow

    Theme {
        id: theme
    }

    width: theme.controlSize
    height: theme.controlSize
    radius: 999
    color: mouse.containsMouse ? theme.hoverBg : theme.chipBg

    Image {
        anchors.centerIn: parent
        width: theme.trayIconSize
        height: theme.trayIconSize
        source: root.item.icon
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton)
                root.item.activate()
            else if (mouse.button === Qt.MiddleButton)
                root.item.secondaryActivate()
            else if (mouse.button === Qt.RightButton && root.item.hasMenu)
                root.item.display(root.panelWindow, parent.x + parent.width, parent.y + parent.height / 2)
        }

        onWheel: function(wheel) {
            root.item.scroll(wheel.angleDelta.y, false)
        }
    }
}
