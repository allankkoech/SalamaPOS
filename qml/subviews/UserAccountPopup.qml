import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4 as Controls2

import "../components"

Controls2.Popup
{
    id: root
    width: 500
    height: 600

    x: (mainApp.width - width)/2
    y: (mainApp.height - height)/2

    modal: true
    closePolicy: Controls2.Popup.NoAutoClose

    property bool isNewUserAccount: true

    property bool editable: true
    property alias isError: err.visible
    property alias errorText: err.text
    property alias ufname: fname.text
    property alias ulname: lname.text
    property alias u_name: uname.text
    property alias uphone: phoneNo.text
    property alias pass: pswd.text
    property alias cpass: cpswd.text

    onClosed: {
        isError = false;
        ufname = "";
        ulname = "";
        u_name = "";
        uphone = "";
        pass = "";
        cpass = "";
        editable = true;
    }

    contentItem: Rectangle
    {
        color: QmlInterface.isDarkTheme? "#1e2027":bgColor
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
                    opacity: 0.08

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                }

                AppText
                {
                    color: QmlInterface.isDarkTheme? "#999fa6":"#2e2e2e"
                    size: 17
                    text: isNewUserAccount? qsTr("New User Account Window"):editable? qsTr("Update My Account Details"):qsTr("View My Account")

                    anchors.centerIn: parent
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout
                {
                    anchors.fill: parent
                    spacing: 10

                    AppTextInput
                    {
                        id: fname
                        prefWidth: 150
                        readOnly: !isNewUserAccount && !editable
                        label: qsTr("Firstname")
                        hintText: qsTr("Enter firstname")
                        validator: RegExpValidator {regExp: RegExp("[a-zA-Z]+")}
                    }

                    AppTextInput
                    {
                        id: lname
                        prefWidth: 150
                        readOnly: !isNewUserAccount && !editable
                        label: qsTr("Lastname")
                        hintText: qsTr("Enter lastname")
                        validator: RegExpValidator {regExp: RegExp("[a-zA-Z]+")}
                    }

                    AppTextInput
                    {
                        id: uname
                        prefWidth: 150
                        label: qsTr("Username")
                        readOnly: !isNewUserAccount && !editable
                        hintText: qsTr("Choose a username")
                        RegExpValidator {regExp: RegExp("[a-zA-Z0-9]+")}
                    }

                    AppTextInput
                    {
                        id: phoneNo
                        prefWidth: 150
                        readOnly: !isNewUserAccount && !editable
                        label: qsTr("Mobile Phone")
                        hintText: qsTr("Enter phone number")
                        validator: DoubleValidator{ bottom: 0 ; top: 100000000000}
                    }

                    AppTextInput
                    {
                        id: pswd
                        visible: isNewUserAccount // && !editable
                        prefWidth: 150
                        label: qsTr("Password")
                        hintText: qsTr("Pick a password")
                        echoMode: TextInput.Password
                    }

                    AppTextInput
                    {
                        id: cpswd
                        visible: isNewUserAccount
                        prefWidth: 150
                        label: qsTr("Confirm password")
                        hintText: qsTr("Re-enter password")
                        echoMode: TextInput.Password
                    }

                    AppText
                    {
                        id: err
                        Layout.fillWidth: true
                        Layout.preferredHeight: 25
                        horizontalAlignment: AppText.AlignHCenter
                        verticalAlignment: AppText.AlignVCenter
                        color: "red"
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

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
                                    text: editable? qsTr("Cancel"):qsTr("Close")

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
                                Layout.preferredWidth: 150

                                color: menuColor
                                radius: 3
                                visible: editable

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
                                        text: isNewUserAccount? qsTr("Add User"):qsTr("Update User")
                                    }
                                }

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (isNewUserAccount)
                                        {
                                            if(ufname!=="" && ulname!=="" && u_name!=="" && uphone!=="" && pass !=="" && cpass!=="")
                                            {
                                                if(pass === cpass)
                                                {
                                                    var tmspt = new Date().getTime();
                                                    AccountsModel.addNewUserAccount(ufname, ulname,u_name,pass,uphone, tmspt);
                                                }

                                                else
                                                {
                                                    isError = true;
                                                    errorText = qsTr("Passwords do not match")
                                                    console.log("Passwords do not match")
                                                }
                                            }

                                            else
                                            {
                                                isError = true;
                                                errorText = qsTr("Some required fields are short!")
                                            }
                                        }

                                        else
                                        {
                                            if(ufname!=="" && ulname!=="" && u_name!=="" && uphone!=="")
                                            {
                                                AccountsModel.updateUserAccount(ufname, ulname,u_name,uphone, loggedUser_username);
                                            }

                                            else
                                            {
                                                isError = true;
                                                errorText = qsTr("Some required fields are short!")
                                            }
                                        }
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
        target: AccountsModel

        function onUserAddedChanged(status)
        {
            if(status)
            {
                console.log(" [INFO] User Added Successfuly!");
                root.close();
            }

            else
                console.log(" [ERROR] Error Adding User");
        }

        function onUserUpdatedChanged(status)
        {
            if(status)
            {
                console.log(" [INFO] User Details updated Successfuly!");
                // resetFields();
                root.close();
            }

            else
                console.log(" [ERROR] Error Updating User");
        }

        function onUsernameExistsChanged(status)
        {
            console.log(">> [ERROR] Username taken")
            isError = true;
            errorText = qsTr("The username is already taken!")
        }
    }

    function resetFields()
    {
        ufname = ""
        ulname = ""
        uname = ""
        uphone = ""
        pass = ""
        cpass = ""
    }
}
