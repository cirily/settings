/*
 * Copyright (C) 2021 Piscesys Team.
 *
 * Author:     revenmartin <revenmartin@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import FishUI 1.0 as FishUI

Item {
    id: control

    property var iconSpacing: FishUI.Units.smallSpacing * 0.8
    property alias source: icon.source
    property alias text: label.text
    property bool checked: false

    property var iconSize: 96

    signal clicked

    implicitHeight: mainLayout.implicitHeight
    implicitWidth: mainLayout.implicitWidth

    scale: 1.0

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        Rectangle {
            id: _box
            width: control.iconSize
            height: width
            color: "transparent"
            border.width: 3
            border.color: control.checked ? FishUI.Theme.highlightColor : "transparent"

            radius: FishUI.Theme.bigRadius + control.iconSpacing
            visible: true

            Image {
                id: icon
                anchors.fill: parent
                anchors.margins: FishUI.Units.smallSpacing
                sourceSize: Qt.size(icon.width, icon.height)
                opacity: 1
                smooth: false

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: icon.width
                        height: icon.height

                        Rectangle {
                            anchors.fill: parent
                            radius: FishUI.Theme.bigRadius
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutSine
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: function() {
                        icon.opacity = 0.8
                    }
                    onExited: function() {
                        icon.opacity = 1.0
                    }
                }
            }
        }

        Label {
            id: label
            color: control.checked ? FishUI.Theme.highlightColor : FishUI.Theme.textColor
            visible: label.text
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutSine
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()

        onPressedChanged: {
            control.scale = pressed ? 0.95 : 1.0
        }
    }
}
