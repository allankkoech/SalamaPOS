import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "../components"
import "../subviews"
import "../delegates"

Rectangle {
    id: mainAppViewRoot
    anchors.fill: parent
    color: bgColor // QmlInterface.isDarkTheme? "#1e2027":"#f4f9fa"//"#f4f9fa"

    property int navBarIndex: 7
    property string viewText: qsTr("Home")
    property int updateInd: 0

    property alias checkoutPopup: checkoutPopup
    property alias userMenuPopup: userMenuPopup
    property alias addRemoveStockPopup: addRemoveStockPopup
    property alias checkoutQtyPopup: checkoutQtyPopup
    property alias userAccountPopup: userAccountPopup
    property alias accountsPopup: accountsPopup
    property alias selectCrediteeOnSale: selectCrediteeOnSale
    property alias salesSummaryDialog: salesSummaryDialog
    property alias messageBox: messageBox
    property alias alarmsPopup: alarmsPopup
    property alias stockHistoryWindow: stockHistoryWindow
    property alias adminSalesWindow: adminSalesWindow
    property alias passwordResetPopup: passwordResetPopup

    onNavBarIndexChanged: {
        switch(navBarIndex)
        {
        case 0:
            viewText = qsTr("Home")
            break;
        case 1:
            viewText = qsTr("Product Checkout")
            break;
        case 2:
            viewText = qsTr("Product & Stock")
            break;
        case 3:
            viewText = qsTr("Sales")
            break;
        case 4:
            viewText = qsTr("Messages & Notifications")
            break;
        case 5:
            viewText = qsTr("App & System Settings")
            break;
        case 6:
            viewText = qsTr("Users & Accounts")
            break;
        }
    }

    Component.onCompleted: {
        alarmsPopup.open()
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        NavigationBar
        {
            id: navBar
            visible: navBarIndex!==8 && navBarIndex!==7
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0

                NotificationBar
                {
                    id: notificationBar
                    visible: navBarIndex!==8 && navBarIndex!==7
                }

                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    StackLayout
                    {
                        anchors.fill: parent
                        currentIndex: navBarIndex

                        DashboardView {}

                        CheckoutView {}

                        StockView { id: stackStockView }

                        SalesView { id: salesView }

                        MessagesView {}

                        SettingsView {}

                        AccountsView {}

                        SplashView {}

                        LoginView { id: loginView }
                    }
                }

                Rectangle
                {
                    id: updateBar
                    visible: false
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    color: QmlInterface.isDarkTheme? "khaki":"khaki"

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: 10

                        AppText
                        {
                            id: updateLabel
                            Layout.alignment: Qt.AlignVCenter
                            // Layout.leftMargin: 20
                            Layout.fillWidth: true
                            horizontalAlignment: AppText.AlignLeft

                            color: "#2e2e2e"
                            text: qsTr("New version is available, upgrade to the latest version?")
                            size: 15
                        }

                        Rectangle{
                            id: downloadUpdateBtn
                            visible: updateInd===0
                            Layout.minimumHeight: 30
                            Layout.fillHeight: true
                            Layout.preferredWidth: 100
                            color: Qt.darker("khaki", 1.7)

                            Layout.alignment: Qt.AlignVCenter
                            // Layout.rightMargin: 20

                            AppText
                            {
                                color: "white"
                                text: qsTr("Download")
                                size: 15

                                anchors.centerIn: parent
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                height: 30
                                onClicked: {
                                    console.log(">> Download update")
                                    QmlInterface.downloadUpdate()
                                }
                            }
                        }

                        Rectangle{
                            id: installUpdateBtn
                            visible: updateInd===2
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 100
                            color: Qt.darker("khaki", 1.7)

                            Layout.alignment: Qt.AlignVCenter
                            // Layout.rightMargin: 20

                            AppText
                            {
                                color: "white"
                                text: qsTr("Yes, Install")
                                size: 15

                                anchors.centerIn: parent
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Install")
                                    messageBoxUpdate.open();
                                }
                            }
                        }

                        Rectangle{
                            id: downloadingUpdateBtn
                            visible: updateInd===1
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 140
                            color: Qt.darker("khaki", 1.7)

                            Layout.alignment: Qt.AlignVCenter
                            // Layout.rightMargin: 20

                            AppText
                            {
                                id: pUpdateLbl
                                color: "white"
                                text: qsTr("Downloading - 0%")
                                size: 15

                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
        }
    }

    MessageBox
    {
        id: messageBoxUpdate
        text: qsTr("Start the update? Changes will appear after the app is restarted.")
        onAccepted: {
            console.log("Starting update ...")
            QmlInterface.logToFile("INFO", "QML => MainAppView::getUpdate Starting Update")
            QmlInterface.installUpdate();
            messageBoxUpdate.close();
        }
    }

    MessageBox
    {
        id: messageBox
    }

    CheckoutPopup
    {
        id: checkoutPopup
    }

    UserMenuPopup
    {
        id: userMenuPopup
        // onOpened: console.log("Opened")
    }

    NewItemPopup
    {
        id: newItemPopup
    }

    AddRemoveStockPopup
    {
        id: addRemoveStockPopup
    }

    CheckoutQtyEditPopup
    {
        id: checkoutQtyPopup
    }

    UserAccountPopup
    {
        id: userAccountPopup
    }

    PasswordResetPopup {
        id: passwordResetPopup
    }

    AccountsPopup
    {
        id: accountsPopup
    }

    AddItemToCheckoutDialog
    {
        id: addItemToCheckoutDialog
    }

    StockHistoryWindow
    {
        id: stockHistoryWindow
    }

    CreditsAndDebtsDrawer
    {
        id: creditNdebtpopup
    }

    NewCrediteePopup
    {
        id: newCrediteePopup
    }

    CreditRepaymentPopup
    {
        id: creditRepayDialog
    }

    SelectCrediteeOnSale
    {
        id: selectCrediteeOnSale
    }

    SalesSummaryDialog
    {
        id: salesSummaryDialog
    }

    AlarmsPopup
    {
        id: alarmsPopup
    }

    AdminSalesWindow
    {
        id: adminSalesWindow
    }

    function startApp(state)
    {
        if(state)
        {
            navBarIndex = 8
            mainApp.showMaximized();
        }

        else
        {
            navBarIndex = 7
            notificationBar.visible = !true;
            navBar.visible = !true
            mainApp.width = 600;
            mainApp.height = 500;
        }
    }

    Connections
    {
        target: QmlInterface

        function onNewVersionAvailableChanged(version)
        {
            updateBar.visible = true
            updateInd=0
            updateLabel.text = qsTr("New version is available, upgrade to the latest version?")
        }

        function onDownloadFinished(path)
        {
            updateBar.visible = true
            updateLabel.text = qsTr("Download finished, ready to install?")
            updateInd=2
        }

        function onDownloadStarted()
        {
            updateBar.visible = true
            updateLabel.text = qsTr("Downloading updates, please wait ...")
            updateInd = 1
            pUpdateLbl.text = qsTr("Download - 0%")
        }

        function onUpdateProgressChanged(val)
        {
            updateBar.visible = true
            pUpdateLbl.text = qsTr("Downloading - ") + val.toString() + "%"
        }
    }


}
