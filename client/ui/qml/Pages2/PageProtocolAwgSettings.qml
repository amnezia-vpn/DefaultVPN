import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtCore

import SortFilterProxyModel 0.2

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Controls2/TextTypes"
import "../Config"
import "../Components"


PageType {
    id: root

    ColumnLayout {
        id: backButtonLayout

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.topMargin: 20

        BackButtonType {
            id: backButton
        }
    }

    ListView {
        id: listview

        property bool isFocusable: true

        anchors.top: backButtonLayout.bottom
        anchors.bottom: parent.bottom

        width: parent.width

        Keys.onTabPressed: {
            FocusController.nextKeyTabItem()
        }

        Keys.onBacktabPressed: {
            FocusController.previousKeyTabItem()
        }

        Keys.onUpPressed: {
            FocusController.nextKeyUpItem()
        }

        Keys.onDownPressed: {
            FocusController.nextKeyDownItem()
        }

        Keys.onLeftPressed: {
            FocusController.nextKeyLeftItem()
        }

        Keys.onRightPressed: {
            FocusController.nextKeyRightItem()
        }

        clip: true

        model: AwgConfigModel

        delegate: Item {
            id: delegateItem
            implicitWidth: listview.width
            implicitHeight: col.implicitHeight

            property alias vpnAddressSubnetTextField: vpnAddressSubnetTextField
            property bool isEnabled: ServersModel.isProcessedServerHasWriteAccess()

            ColumnLayout {
                id: col

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.leftMargin: 16
                anchors.rightMargin: 16

                spacing: 0

                HeaderType {
                    Layout.fillWidth: true

                    headerText: qsTr("AmneziaWG settings")
                }

                TextFieldWithHeaderType {
                    id: vpnAddressSubnetTextField

                    Layout.fillWidth: true
                    Layout.topMargin: 40

                    enabled: delegateItem.isEnabled

                    headerText: qsTr("VPN address subnet")
                    textField.text: subnetAddress

                    textField.onEditingFinished: {
                        if (textField.text !== subnetAddress) {
                            subnetAddress = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: portTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    enabled: delegateItem.isEnabled

                    headerText: qsTr("Port")
                    textField.text: port
                    textField.maximumLength: 5
                    textField.validator: IntValidator { bottom: 1; top: 65535 }

                    textField.onEditingFinished: {
                        if (textField.text !== port) {
                            port = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: junkPacketCountTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("Jc - Junk packet count")
                    textField.text: serverJunkPacketCount
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text === "") {
                            textField.text = "0"
                        }

                        if (textField.text !== serverJunkPacketCount) {
                            serverJunkPacketCount = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: junkPacketMinSizeTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("Jmin - Junk packet minimum size")
                    textField.text: serverJunkPacketMinSize
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverJunkPacketMinSize) {
                            serverJunkPacketMinSize = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: junkPacketMaxSizeTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("Jmax - Junk packet maximum size")
                    textField.text: serverJunkPacketMaxSize
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverJunkPacketMaxSize) {
                            serverJunkPacketMaxSize = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: initPacketJunkSizeTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("S1 - Init packet junk size")
                    textField.text: serverInitPacketJunkSize
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverInitPacketJunkSize) {
                            serverInitPacketJunkSize = textField.text
                        }
                    }

                    checkEmptyText: true

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            listview.positionViewAtEnd()
                        }
                    }
                }

                TextFieldWithHeaderType {
                    id: responsePacketJunkSizeTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("S2 - Response packet junk size")
                    textField.text: serverResponsePacketJunkSize
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverResponsePacketJunkSize) {
                            serverResponsePacketJunkSize = textField.text
                        }
                    }

                    checkEmptyText: true

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            listview.positionViewAtEnd()
                        }
                    }
                }

                TextFieldWithHeaderType {
                    id: initPacketMagicHeaderTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("H1 - Init packet magic header")
                    textField.text: serverInitPacketMagicHeader
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverInitPacketMagicHeader) {
                            serverInitPacketMagicHeader = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: responsePacketMagicHeaderTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("H2 - Response packet magic header")
                    textField.text: serverResponsePacketMagicHeader
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverResponsePacketMagicHeader) {
                            serverResponsePacketMagicHeader = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: transportPacketMagicHeaderTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("H4 - Transport packet magic header")
                    textField.text: serverTransportPacketMagicHeader
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverTransportPacketMagicHeader) {
                            serverTransportPacketMagicHeader = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                TextFieldWithHeaderType {
                    id: underloadPacketMagicHeaderTextField
                    Layout.fillWidth: true
                    Layout.topMargin: 16

                    headerText: qsTr("H3 - Underload packet magic header")
                    textField.text: serverUnderloadPacketMagicHeader
                    textField.validator: IntValidator { bottom: 0 }

                    textField.onEditingFinished: {
                        if (textField.text !== serverUnderloadPacketMagicHeader) {
                            serverUnderloadPacketMagicHeader = textField.text
                        }
                    }

                    checkEmptyText: true
                }

                BasicButtonType {
                    id: saveRestartButton

                    Layout.fillWidth: true
                    Layout.topMargin: 24
                    Layout.bottomMargin: 24

                    enabled: underloadPacketMagicHeaderTextField.errorText === "" &&
                             transportPacketMagicHeaderTextField.errorText === "" &&
                             responsePacketMagicHeaderTextField.errorText === "" &&
                             initPacketMagicHeaderTextField.errorText === "" &&
                             responsePacketJunkSizeTextField.errorText === "" &&
                             initPacketJunkSizeTextField.errorText === "" &&
                             junkPacketMaxSizeTextField.errorText === "" &&
                             junkPacketMinSizeTextField.errorText === "" &&
                             junkPacketCountTextField.errorText === "" &&
                             portTextField.errorText === "" &&
                             vpnAddressSubnetTextField.errorText === ""

                    text: qsTr("Save")

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            listview.positionViewAtEnd()
                        }
                    }

                    clickedFunc: function() {
                        forceActiveFocus()

                        if (delegateItem.isEnabled) {
                            if (AwgConfigModel.isHeadersEqual(underloadPacketMagicHeaderTextField.textField.text,
                                                              transportPacketMagicHeaderTextField.textField.text,
                                                              responsePacketMagicHeaderTextField.textField.text,
                                                              initPacketMagicHeaderTextField.textField.text)) {
                                PageController.showErrorMessage(qsTr("The values of the H1-H4 fields must be unique"))
                                return
                            }

                            if (AwgConfigModel.isPacketSizeEqual(parseInt(initPacketJunkSizeTextField.textField.text),
                                                                 parseInt(responsePacketJunkSizeTextField.textField.text))) {
                                PageController.showErrorMessage(qsTr("The value of the field S1 + message initiation size (148) must not equal S2 + message response size (92)"))
                                return
                            }
                        }

                        var headerText = qsTr("Save settings?")
                        var descriptionText = qsTr("All users with whom you shared a connection with will no longer be able to connect to it.")
                        var yesButtonText = qsTr("Continue")
                        var noButtonText = qsTr("Cancel")

                        var yesButtonFunction = function() {
                            if (ConnectionController.isConnected && ServersModel.getDefaultServerData("defaultContainer") === ContainersModel.getProcessedContainerIndex()) {
                                PageController.showNotificationMessage(qsTr("Unable change settings while there is an active connection"))
                                return
                            }

                            PageController.goToPage(PageEnum.PageSetupWizardInstalling);
                            InstallController.updateContainer(AwgConfigModel.getConfig())
                        }
                        var noButtonFunction = function() {
                            if (!GC.isMobile()) {
                                saveRestartButton.forceActiveFocus()
                            }
                        }
                        showQuestionDrawer(headerText, descriptionText, yesButtonText, noButtonText, yesButtonFunction, noButtonFunction)
                    }
                }
            }
        }
    }
}
