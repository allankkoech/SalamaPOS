import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4 as Controls2

import "../components"
import "../subviews"
import "../delegates"

Item {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.margins: 50

    property var currentScreen: 0

    ColumnLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        anchors.bottomMargin: 30
        spacing: 10

        Item
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 70

            Rectangle
            {
                width: parent.width
                height: 3
                color: "#d3e5ff"

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 3
            }

            RowLayout
            {
                anchors.fill: parent
                spacing: 1

                HorizontalSpacer {}


                Rectangle
                {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignVCenter

                    color: menuColor
                    radius: 4

                    RowLayout
                    {
                        anchors.centerIn: parent

                        spacing: 10

                        AppIcon
                        {
                            color: "white"
                            size: 15
                            icon: "\uf234"
                        }

                        AppText
                        {
                            color: "white"
                            size: 15
                            text:  qsTr("Add New User")
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: userAccountPopup.open()
                    }
                }
            }
        }

        Rectangle
        {
            radius: 2
            border.color: "grey"
            border.width: 1

            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0

                UserAccountsHeader {}

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "grey"
                }

                Controls2.ScrollView
                {
                    id: scroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 1
                    clip: true

                    ListView
                    {
                        anchors.fill: parent
                        spacing: 0

                        model: AccountsModel

                        delegate: Component {
                            id: userAccountDelegate

                            UserAccountsDelegate
                            {
                                width: scroll.width

                                _index: model.index
                                fname: user_fname
                                lname: user_lname
                                uname: user_username
                                phoneNo: user_phoneNo
                                date: date_added
                                canCreateUser: can_addUsers
                                canDeleteUser: can_removeUsers
                                canCreateItems: can_addProducts
                                canDeleteItems: can_removeProducts
                                canAddStock: can_addStock
                                canDeleteStock: can_removeStock
                                canDeleteSales: can_undoSales
                                canBackupDb: can_backup

                                onEditedChanged: {
                                    accountsPopup.open();
                                    accountsPopup.currentIndex = index
                                    accountsPopup.currentUser = uname
                                    accountsPopup.canCreateUser = canCreateUser
                                    accountsPopup.canDeleteUser = canDeleteUser
                                    accountsPopup.canCreateItems = canCreateItems
                                    accountsPopup.canDeleteItems = canDeleteItems
                                    accountsPopup.canAddStock = canAddStock
                                    accountsPopup.canDeleteStock = canDeleteStock
                                    accountsPopup.canDeleteSales = canDeleteSales
                                    accountsPopup.canBackupDb = canBackupDb
                                }
                            }
                        }
                    }

                }
            }
        }

    }
}
