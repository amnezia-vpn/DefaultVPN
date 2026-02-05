pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Config 1.0

import "../Components"
import "../Controls"
import "../Controls/TextTypes"

Page {
    id: root

    Connections {
        target: InstallController

        function onRemoveProcessedServerFinished(finishedMessage) {
            if (!ServersModel.getServersCount()) {
                PageController.goToStartPage()
            } else {
                PageController.closePage()
            }
            PageController.showNotificationMessage(finishedMessage)
        }

        function onApiConfigRemoved(message) {
            PageController.showNotificationMessage(message)
        }
    }

    ColumnLayout {
        anchors.fill: parent

        spacing: 0

        RowLayout {
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8

            WhiteButtonNoBorder {
                id: backButton
                imageSource: "qrc:/images/controls/arrow-left.svg"

                onClicked: PageController.closePage()
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Header1TextType {
            id: header

            Layout.topMargin: 8
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.bottomMargin: 24
            Layout.fillWidth: true

            text: ServersModel.getProcessedServerData("name") + " " + qsTr("Server settings")

            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }

        XSmallTextType {
            visible: false

            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.bottomMargin: 8
            Layout.fillWidth: true

            text: qsTr("Name")
        }

        InputType {
            visible: false

            id: textKey

            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.fillWidth: true
        }

        WhiteButtonWithBorder {
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 24
            Layout.fillWidth: true

            text: qsTr("Rename server")
            defaultTextColor: Style.color.black
            hoveredTextColor: Style.color.black
            pressedTextColor: Style.color.black

            onClicked: renameServerPopup.open()
        }

        WhiteButtonWithBorder {
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 12
            Layout.fillWidth: true
            
            text: qsTr("Reset API Configuration")
            defaultTextColor: Style.color.error
            hoveredTextColor: Style.color.error
            pressedTextColor: Style.color.error

            onClicked: {
                if (ServersModel.isDefaultServerCurrentlyProcessed() && ConnectionController.isConnected) {
                    PageController.showNotificationMessage(qsTr("Cannot reset API config during active connection"))
                } else {
                    resetConfirmationDialog.open()
                }
            }
        }

        WhiteButtonWithBorder {
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 24
            Layout.fillWidth: true

            text: qsTr("Delete server")
            defaultTextColor: Style.color.error
            hoveredTextColor: Style.color.error
            pressedTextColor: Style.color.error

            onClicked: deleteConfirmationDialog.open()
        }

        Item {
            Layout.fillHeight: true
        }
    }

    TextInputPopup {
        id: renameServerPopup
        titleText: qsTr("Server name")
        placeholderText: qsTr("Enter server name")
        confirmButtonText: qsTr("Save")
        textValue: ServersModel.getProcessedServerData("name")
        maximumLength: 30
        requireNonEmpty: true
        onConfirm: function(newName) {
            ServersModel.setProcessedServerData("name", newName)
            PageController.showNotificationMessage(qsTr("Server renamed successfully"))
            header.text = newName + " " + qsTr("Server settings")
        }
    }

    ConfirmationDialog {
        id: resetConfirmationDialog
        title: qsTr("Do you want to reboot the server?")
        confirmButtonText: qsTr("Continue")
        cancelButtonText: qsTr("Cancel")
        
        onConfirm: function() {
            PageController.showBusyIndicator(true)
            InstallController.rebootProcessedServer()
            PageController.showBusyIndicator(false)
        }
    }

    ConfirmationDialog {
        id: deleteConfirmationDialog
        title: qsTr("Are you sure you want to remove the server from the app?")
        description: qsTr("You won't be able to connect to it")
        confirmButtonText: qsTr("Yes, delete anyway")
        cancelButtonText: qsTr("No, keep it")
        
        onConfirm: function() {
            PageController.showBusyIndicator(true)
            InstallController.removeProcessedServer()
            PageController.showBusyIndicator(false)
        }
    }
}
