import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"

Item
{
    Layout.fillWidth: true
    Layout.preferredHeight: 100

    property string label: ""
    property string _icon

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        Rectangle
        {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            color: Qt.darker(menuColor)

            AppIcon
            {
                anchors.centerIn: parent

                size: 30
                color: "white"
                icon: _icon
            }

        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: menuColor

            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0

                Item
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    AppText
                    {
                        text: label
                        size: 17
                        color: "white"

                        anchors.centerIn: parent
                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 3
                    color: Qt.darker(menuColor)
                    opacity: 0.35
                }

                Item
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    RowLayout
                    {
                        height: 40
                        width: parent.width - 20
                        anchors.centerIn: parent

                        AppText
                        {
                            Layout.alignment: Qt.AlignVCenter

                            text: qsTr("Ksh.")
                            size: 20
                            color: "white"
                        }

                        Rectangle
                        {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            color: "white"
                            radius: 2
                            clip: true

                            TextInput
                            {
                                anchors.fill: parent
                                verticalAlignment: TextInput.AlignVCenter
                                horizontalAlignment: TextInput.AlignLeft
                                anchors.leftMargin: 5

                                color: "black"
                                font.pixelSize: 25
                                font.family: montserratFontLoader.name
                                selectByMouse: true
                                clip: true

                                AppText{
                                    size: parent.font.pixelSize-2
                                    color: "grey"
                                    text: qsTr("0.00")
                                    visible: parent.text===""

                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

