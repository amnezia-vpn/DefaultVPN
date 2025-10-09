pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Config 1.0

import SortFilterProxyModel 0.2

import "../Components"
import "../Controls"
import "../Controls/TextTypes"

Page {
    id: root

    property var processedServer

    Connections {
        target: ServersModel

        function onProcessedServerChanged() {
            root.processedServer = proxyServersModel.get(0)
        }
    }

    Connections {
        target: ApiConfigsController
    
        function onReloadServerFromApiFinished(message) {
            PageController.showNotificationMessage(message)
        }
    }

    SortFilterProxyModel {
        id: proxyServersModel
        objectName: "proxyServersModel"

        sourceModel: ServersModel
        filters: [
            ValueFilter {
                roleName: "isCurrentlyProcessed"
                value: true
            }
        ]

        Component.onCompleted: {
            root.processedServer = proxyServersModel.get(0)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        RowLayout {
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

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8
            spacing: 0

            Header1TextType {
                id: header

                Layout.fillWidth: true

                text: root.processedServer.name

                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
            }

            XSmallTextType {
                Layout.topMargin: 24
                Layout.fillWidth: true

                text: qsTr("Subscription expires on")
                color: Style.color.black
            }

            MediumTextType {
                Layout.topMargin: 6
                Layout.fillWidth: true

                text: ApiAccountInfoModel.data("endDate")
                color: Style.color.black
            }

            SwitcherType {
                id: switcher

                readonly property bool isVlessProtocol: ApiConfigsController.isVlessProtocol()

                Layout.fillWidth: true
                Layout.topMargin: 16

                visible: ApiAccountInfoModel.data("isProtocolSelectionSupported")

                text: qsTr("Use VLESS protocol")
                checked: switcher.isVlessProtocol
                onToggled: function() {
                    if (ServersModel.isDefaultServerCurrentlyProcessed() && ConnectionController.isConnected) {
                        PageController.showNotificationMessage(qsTr("Cannot change protocol during active connection"))
                    } else {
                        PageController.showBusyIndicator(true)
                        ApiConfigsController.setCurrentProtocol(switcher.isVlessProtocol ? "awg" : "vless")
                        ApiConfigsController.updateServiceFromGateway(ServersModel.processedIndex, "", "", true)
                        PageController.showBusyIndicator(false)
                    }
                }
            }

            WhiteButtonWithBorder {
                Layout.topMargin: 16
                Layout.fillWidth: true
                
                text: qsTr("Reload API configuration")

                onClicked: {
                    if (ServersModel.isDefaultServerCurrentlyProcessed() && ConnectionController.isConnected) {
                        PageController.showNotificationMessage(qsTr("Cannot reload API config during active connection"))
                    } else {
                        resetConfirmationDialog.open()
                    }
                }
            }

            WhiteButtonWithBorder {
                Layout.topMargin: 24
                Layout.fillWidth: true

                text: qsTr("Rename server")
                defaultTextColor: Style.color.black
                hoveredTextColor: Style.color.black
                pressedTextColor: Style.color.black

                onClicked: renameServerPopup.open()
            }

            WhiteButtonWithBorder {
                Layout.topMargin: 12
                Layout.fillWidth: true
                
                text: qsTr("Delete")
                defaultTextColor: Style.color.error
                hoveredTextColor: Style.color.error
                pressedTextColor: Style.color.error

                onClicked: {
                    if (ServersModel.isDefaultServerCurrentlyProcessed() && ConnectionController.isConnected) {
                        PageController.showNotificationMessage(qsTr("Cannot remove server during active connection"))
                    } else {
                        deleteConfirmationDialog.open()
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
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
            header.text = newName + " " + qsTr("Amnezia Premium settings")
        }
    }

    ConfirmationDialog {
        id: resetConfirmationDialog
        title: qsTr("Reset API configuration?")
        description: qsTr("This will reload the API configuration from the server")
        confirmButtonText: qsTr("Reset")
        cancelButtonText: qsTr("Cancel")
        
        onConfirm: function() {
            PageController.showBusyIndicator(true)
            ApiConfigsController.updateServiceFromGateway(ServersModel.processedIndex, "", "", true)
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
            if (ApiConfigsController.deactivateDevice()) {
                InstallController.removeProcessedServer()
                PageController.closePage()
            }
            PageController.showBusyIndicator(false)
        }
    }
} 
