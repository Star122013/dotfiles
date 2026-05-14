import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    Theme {
        id: theme
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    readonly property var activePlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    readonly property string musicTitle: activePlayer ? (activePlayer.trackTitle || activePlayer.identity || "Unknown title") : "No media"
    readonly property string musicArtist: activePlayer ? (activePlayer.trackArtist || activePlayer.identity || "Nothing playing") : "Start a player"

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: bar
                required property var modelData

                screen: modelData
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore

                anchors {
                    right: true
                }

                implicitWidth: wrapper.implicitWidth + 24
                implicitHeight: modelData.height

                Rectangle {
                    id: wrapper
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 16

                    implicitWidth: sectionColumn.implicitWidth + theme.panelPadding * 2
                    implicitHeight: sectionColumn.implicitHeight + theme.panelPadding * 2

                    radius: theme.radiusLg
                    color: theme.panelBg
                    border.width: 1
                    border.color: theme.divider

                    ColumnLayout {
                        id: sectionColumn
                        anchors.fill: parent
                        anchors.margins: theme.panelPadding
                        spacing: theme.sectionSpacing

                        BarSection {
                            first: true
                            title: "󰎆 Media"

                            Text {
                                width: theme.sectionWidth
                                color: theme.text
                                text: root.musicTitle
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                font.pixelSize: 13
                                font.weight: 600
                            }

                            Text {
                                width: theme.sectionWidth
                                color: theme.subtext
                                text: root.musicArtist
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                font.pixelSize: 12
                            }

                            Row {
                                spacing: 6

                                ControlButton {
                                    label: "󰒮"
                                    active: root.activePlayer && root.activePlayer.canGoPrevious
                                    onClicked: root.activePlayer.previous()
                                }

                                ControlButton {
                                    label: root.activePlayer && root.activePlayer.isPlaying ? "󰏤" : "󰐊"
                                    active: root.activePlayer && root.activePlayer.canTogglePlaying
                                    onClicked: root.activePlayer.togglePlaying()
                                }

                                ControlButton {
                                    label: "󰒭"
                                    active: root.activePlayer && root.activePlayer.canGoNext
                                    onClicked: root.activePlayer.next()
                                }
                            }
                        }

                        BarSection {
                            title: "󰀻 Tray"

                            Flow {
                                width: theme.sectionWidth
                                spacing: 8

                                Repeater {
                                    model: SystemTray.items

                                    delegate: TrayButton {
                                        required property var modelData
                                        item: modelData
                                        panelWindow: bar
                                    }
                                }
                            }
                        }

                        BarSection {
                            title: "󰥔 Time"

                            Text {
                                color: theme.text
                                text: Qt.formatDateTime(clock.date, "HH:mm")
                                font.pixelSize: 24
                                font.weight: 700
                            }

                            Text {
                                color: theme.subtext
                                text: Qt.formatDateTime(clock.date, "yyyy-MM-dd")
                                font.pixelSize: 12
                            }

                            Text {
                                color: theme.subtext
                                text: Qt.formatDateTime(clock.date, "ddd")
                                font.pixelSize: 12
                            }
                        }
                    }
                }

                mask: Region {
                    item: wrapper
                    radius: theme.radiusLg
                }
            }
        }
    }
}
