import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property string title
    default property alias contentData: content.data
    property bool first: false

    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + theme.sectionPadding * 2 + titleText.implicitHeight + 6

    color: "transparent"

    Theme {
        id: theme
    }

    Rectangle {
        visible: !root.first
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 1
        color: theme.divider
    }

    Column {
        anchors.fill: parent
        anchors.margins: theme.sectionPadding
        spacing: 6

        Text {
            id: titleText
            color: theme.subtext
            text: root.title
            font.pixelSize: 13
            font.weight: 600
        }

        Column {
            id: content
            width: theme.sectionWidth
            spacing: 8
        }
    }
}
