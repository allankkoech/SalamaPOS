import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4 as Controls2

import "../components"

Controls2.Drawer {
    id: root

    width: 400
    height: mainApp.height
    edge: Qt.RightEdge
    interactive: false
    closePolicy: Controls2.Drawer.NoAutoClose

    property alias cashAmount: cash_p.text
    property alias mpesaAmount: mpesa_p.text
    property alias chequeAmount: cheque_p.text
    property alias creditAmount: credit_p.text

    property string uniqueSaleId: ""
    property string uniqueSaleDate: ""
    property int counter: 0

    signal submitCheckout()

    onOpened: {
        cashAmount: 0
        mpesaAmount: 0
        chequeAmount: 0
        creditAmount: 0
        counter = 0
    }

    contentItem: Rectangle
    {
        color: bgColor
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 10

            Item
            {
                height: 60
                Layout.fillWidth: true

                AppText
                {
                    color: "#535353"
                    size: 18
                    text: qsTr("Complete transaction")

                    anchors.centerIn: parent
                }

                Item
                {
                    height: 40
                    width: 40

                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter

                    AppIcon
                    {
                        icon: "\uf057"
                        size: 30
                        color: "red"

                        anchors.centerIn: parent
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: root.close();
                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 3
                    color: "black"
                    opacity: 0.078

                    anchors.bottom: parent.bottom
                }
            }

            Item {
                id: _x
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.bottomMargin: 20

                Controls2.ScrollView
                {
                    anchors.fill: parent
                    width: _x.width-40
                    clip: true
                    Controls2.ScrollBar.vertical.policy: Controls2.ScrollBar.AlwaysOn

                    ColumnLayout
                    {
                        anchors.fill: parent
                        width: _x.width-40
                        spacing: 20

                        AppText
                        {
                            color: "#555555"
                            size: 40
                            text: qsTr("Sales: Ksh. ") + CheckoutModel.sellTotals.toString()

                            Layout.alignment: Qt.AlignHCenter
                        }

                        CheckoutPaymentItem
                        {
                            // Cash payment
                            id: cash_p

                            Layout.preferredWidth: _x.width-20

                            icon: "\uf555"
                            label: qsTr("Cash Payment")
                        }

                        CheckoutPaymentItem
                        {
                            // M-Pesa Payment
                            id: mpesa_p

                            Layout.preferredWidth: _x.width-20

                            icon: "\uf3ce"
                            label: qsTr("M~Pesa Payment")
                        }

                        CheckoutPaymentItem
                        {
                            // Cheque Payment
                            id: cheque_p

                            Layout.preferredWidth: _x.width-20

                            icon: "\uf53d"
                            label: qsTr("Cheque Payment")
                        }

                        CheckoutPaymentItem
                        {
                            // Credit Payment
                            id: credit_p

                            Layout.preferredWidth: _x.width-20

                            icon: "\uf09d"
                            label: qsTr("Credit Payment")
                        }

                        Rectangle
                        {
                            color: "#0091d9"
                            radius: 10

                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            Layout.margins: 20

                            AppText
                            {
                                color: "white"
                                size: 20
                                text: qsTr("SUBMIT")

                                anchors.centerIn: parent
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    uniqueSaleDate = SalesModel.getCurrentTimeString()
                                    uniqueSaleId = SalesModel.getUniqueSaleId();

                                    var _js = '{ "cash":0, "mpesa":0, "credit":0, "cheque":0 }'
                                    var json = JSON.parse(_js)

                                    json.cash = cashAmount
                                    json.mpesa = mpesaAmount
                                    json.credit = creditAmount
                                    json.cheque = chequeAmount

                                    SalesModel.addPaymentSaleDetails(uniqueSaleId, json);
                                    // json.due_date = Qt.formatDateTime(new Date(), "dd-MM-yyyy")
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
        target: SalesModel

        function onSaleItemAddedChanged(status)
        {
            if(status)
            {
                counter += 1;

                if(counter >= CheckoutModel.checkoutModelSize)
                {
                    CheckoutModel.startANewSell();

                    root.close();

                    console.log(" [INFO] Success Adding Sale Items : " , counter)
                }
            }

            else
            {
                console.log(" [ERROR] Error Adding Sale Items")
            }
        }

        function onPaymentItemAdded(status)
        {
            if(status)
            {
                console.log(" [INFO] Success Payment Details")

                for(var i=0; i<CheckoutModel.checkoutModelSize; i++)
                {
                    var bcode = CheckoutModel.getBarcodeAt(i);
                    var bqty = CheckoutModel.getSellQtyAt(i);

                    SalesModel.addSaleItem(bcode, bqty, loggedUser_username, uniqueSaleId, uniqueSaleDate);
                }
            }

            else
            {
                console.log(" [ERROR] Error Adding Payment Details")
            }
        }

        function onUpdateStockChanged(_barcode, _qty)
        {
            StockItemModel.updateStockOnSale(_barcode, _qty);
        }
    }
}
