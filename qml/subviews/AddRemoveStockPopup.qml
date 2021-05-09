import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4 as Controls2

import "../components"

Controls2.Popup
{
    id: root
    width: 450
    height: 350

    x: (mainApp.width - width)/2
    y: (mainApp.height - height)/2
    modal: true
    closePolicy: Controls2.Popup.NoAutoClose

    property int currentIndex: -1

    property bool hasPermissions: true
    property bool isNewItemMode: true
    property int currentStock: 0
    property string barcode: ""
    property alias combo: combo
    property int valueQty: parseInt(addRemoveStock.value)

    signal accepted()

    onClosed: {
        combo.currentIndex = 0;
        currentStock = 0;
        addRemoveStock.value = '';
    }

    onOpened: {
        if(loggedUser_canAddItems)
        {
            combo.currentIndex = 0;

            if(!loggedUser_canDeleteStock)
            {
                combo.enabled = false;
            }
        }

        else
        {
            combo.currentIndex = 1;
            combo.enabled = false;
        }
    }


    contentItem: Rectangle
    {
        color: bgColor
        anchors.fill: parent


        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 30

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Rectangle
                {
                    color: "black"
                    height: 3
                    width: parent.width
                    opacity: 0.1

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                }

                AppText
                {
                    color: QmlInterface.isDarkTheme? "grey":"black"
                    size: 20
                    text: qsTr("Stock Dialog")

                    anchors.centerIn: parent
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 10

                    AppText
                    {
                        size: 18
                        color: QmlInterface.isDarkTheme? "grey":"black"
                        text: qsTr("Stock Action")

                        Layout.preferredWidth: 200
                        horizontalAlignment: AppText.AlignLeft
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Controls2.ComboBox
                    {
                        id: combo
                        enabled: hasPermissions
                        font.bold: true
                        currentIndex: 0
                        model: ["Add Stock", "Reduce Stock"]

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 10

                    AppText
                    {
                        size: 18
                        color: QmlInterface.isDarkTheme? "grey":"black"
                        text: qsTr("Quantity in Stock")

                        Layout.preferredWidth: 200
                        horizontalAlignment: AppText.AlignLeft
                        Layout.alignment: Qt.AlignVCenter
                    }

                    StockQtyInputBox
                    {
                        value: currentStock.toString();
                        input.readOnly: true
                        input.font.bold: true
                    }
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 10

                    AppText
                    {
                        size: 18
                        color: QmlInterface.isDarkTheme? "grey":"black"
                        text: combo.currentIndex===0? qsTr("Quantity to Add"):qsTr("Quantity to Remove")

                        Layout.preferredWidth: 200
                        horizontalAlignment: AppText.AlignLeft
                        Layout.alignment: Qt.AlignVCenter
                    }

                    StockQtyInputBox
                    {
                        id: addRemoveStock
                    }
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 10

                    HorizontalSpacer {}

                    Rectangle
                    {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        color: menuColor
                        radius: 3


                        AppText
                        {
                            color: "white"
                            size: 15
                            text: qsTr("Cancel")

                            anchors.centerIn: parent
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: root.close()
                        }
                    }

                    Rectangle
                    {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 120

                        color: menuColor
                        radius: 3

                        RowLayout
                        {
                            anchors.centerIn: parent

                            spacing: 10

                            AppIcon
                            {
                                color: "white"
                                size: 15
                                icon: "\uf067"
                            }

                            AppText
                            {
                                color: "white"
                                size: 15
                                text: qsTr("Update")
                            }
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: {
                                var dte = StockItemModel.getCurrentTime();

                                if(combo.currentIndex===0)
                                {
                                    if(valueQty > 0)
                                    {
                                        console.log('Adding ', valueQty, ' to Stock.')
                                        StockItemModel.updateStock(barcode, valueQty+currentStock, dte, currentIndex)
                                        StockItemModel.updateStockHistory(barcode, currentStock, valueQty, dte, loggedUser_username, true)
                                    }

                                    else
                                    {
                                        console.log("Adding a zero qty to stock")
                                        AlarmsModel.addAlarmItem("error", "Quantity is ZERO!")
                                    }
                                }

                                else
                                {
                                    if( valueQty <= currentStock && valueQty>0 && hasPermissions )
                                    {
                                        console.log("Removing ", valueQty, " from Stock.")

                                        StockItemModel.updateStock(barcode, currentStock-valueQty, dte, currentIndex)
                                        StockItemModel.updateStockHistory(barcode, currentStock, valueQty, dte, loggedUser_username, false)
                                    }

                                    else
                                    {
                                        if( valueQty > currentStock )
                                            AlarmsModel.addAlarmItem("error", "Quantity entered exceeds quantity available")

                                        else if( !hasPermissions )
                                            AlarmsModel.addAlarmItem("error", "This can only be done by ADMINs.")

                                        else if( valueQty === 0 )
                                            AlarmsModel.addAlarmItem("error", "Quantity is ZERO!")

                                        console.log("Removing 0 items from Stock OR Quantity to remove exceeds qty available OR You dont have permissions to do such!")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Connections
    {
        target: StockItemModel

        function onItemStockChanged(state)
        {
            if(state)
            {
                console.log("Stock update successful!");
                AlarmsModel.addAlarmItem("info", "Stock update successful")
                root.close();
            }

            else
            {
                console.log("Stock update failed!");
                AlarmsModel.addAlarmItem("error", "Stock update failed")
            }
        }
    }
}
