/*
 * Copyright (C) 2021 Piscesys Team.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
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

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import FishUI 1.0 as FishUI
import Pisces.Settings 1.0
import Pisces.Accounts 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Mouse")

    CursorThemeModel {
        id: cursorModel
    }

    Mouse {
        id: mouse
    }

    function syncValues() {
        accelerationSlider.init()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: FishUI.Units.largeSpacing * 2

            RoundedItem {
                GridLayout {
                    columns: 2
                    columnSpacing: FishUI.Units.largeSpacing * 1.5
                    rowSpacing: FishUI.Units.largeSpacing * 2

                    Label {
                        text: qsTr("Left hand")
                        Layout.fillWidth: true
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: mouse.leftHanded
                        rightPadding: 0
                        onCheckedChanged: mouse.leftHanded = checked
                    }

                    Label {
                        text: qsTr("Natural scrolling")
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: mouse.naturalScroll
                        onCheckedChanged: mouse.naturalScroll = checked
                        rightPadding: 0
                    }

//                    Label {
//                        text: qsTr("Mouse acceleration")
//                    }

//                    Switch {
//                        Layout.fillHeight: true
//                        Layout.alignment: Qt.AlignRight
//                        checked: mouse.acceleration
//                        onCheckableChanged: mouse.acceleration = checked
//                        rightPadding: 0
//                    }

//                    Label {
//                        text: qsTr("Disable touchpad when mouse is connected")
//                    }

//                    Switch {
//                        Layout.fillHeight: true
//                        Layout.alignment: Qt.AlignRight
//                        rightPadding: 0
//                    }
                }

                HorizontalDivider {}

                RowLayout {
                    spacing: FishUI.Units.largeSpacing * 2

                    Label {
                        text: qsTr("Pointer speed")
                    }

                    Slider {
                        id: accelerationSlider
                        Layout.fillWidth: true
                        rightPadding: FishUI.Units.largeSpacing
                        from: 1
                        to: 11
                        stepSize: 1

                        function init() {
                            accelerationSlider.value = 6 + mouse.pointerAcceleration / 0.2
                        }

                        Component.onCompleted: init()

                        onPressedChanged: {
                            mouse.pointerAcceleration = Math.round(((value - 6) * 0.2) * 10) / 10
                        }
                    }
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Theme")
                    color: FishUI.Theme.disabledTextColor
                    visible: _view.count > 0
                }

                GridView {
                    id: _view
                    Layout.fillWidth: true
                    implicitHeight: Math.ceil(_view.count / rowCount) * cellHeight + FishUI.Units.largeSpacing
                    model: cursorModel
                    interactive: false
                    visible: _view.count > 0

                    leftMargin: 0
                    rightMargin: 0

                    cellHeight: itemHeight
                    cellWidth: calcExtraSpacing(itemWidth, _view.width) + itemWidth

                    currentIndex: cursorModel.themeIndex(cursorModel.currentTheme)

                    property int rowCount: _view.width / itemWidth
                    property int itemWidth: 128
                    property int itemHeight: 128

                    function calcExtraSpacing(cellSize, containerSize) {
                        var availableColumns = Math.floor(containerSize / cellSize)
                        var extraSpacing = 0
                        if (availableColumns > 0) {
                            var allColumnSize = availableColumns * cellSize
                            var extraSpace = Math.max(containerSize - allColumnSize, 0)
                            extraSpacing = extraSpace / availableColumns
                        }
                        return Math.floor(extraSpacing)
                    }

                    delegate: Item {
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        scale: _mouseArea.pressed ? 0.95 : 1.0

                        property bool isCurrent: _view.currentIndex === index

                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutSine
                            }
                        }

                        MouseArea {
                            id: _mouseArea
                            anchors.fill: parent
                            anchors.margins: FishUI.Units.smallSpacing * 1.5
                            onClicked: {
                                _view.currentIndex = index
                                cursorModel.currentTheme = model.id
                                console.log(model.id)
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: FishUI.Units.smallSpacing * 1.5
                            color: FishUI.Theme.darkMode ? "#3C3C3C" : "#FAFAFA"
                            radius: FishUI.Theme.mediumRadius
                            z: -1

                            border.width: isCurrent ? 3 : 0
                            border.color: FishUI.Theme.highlightColor
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: FishUI.Units.smallSpacing * 1.5

                            Item {
                                Layout.fillHeight: true
                            }

                            Item {
                                height: FishUI.Units.largeSpacing
                            }

                            FishUI.IconItem {
                                width: 22
                                height: 22
                                source: model.image
                                smooth: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Item {
                                Layout.fillHeight: true
                            }

                            Label {
                                text: model.name
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                                bottomPadding: FishUI.Units.largeSpacing
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }
                }
            }

            Item {
                height: FishUI.Units.smallSpacing
            }
        }
    }
}
