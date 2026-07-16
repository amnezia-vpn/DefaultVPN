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

    property var apiAvailableProtocols: []
    property string apiCurrentProtocol: ""

    readonly property bool isApiProtocolSelectionVisible: ServersModel.isDefaultServerFromApi && root.apiAvailableProtocols.length > 0

    readonly property string longestProtocolName: {
        var longest = ""
        for (var i = 0; i < root.apiAvailableProtocols.length; ++i) {
            var name = root.protocolDisplayName(root.apiAvailableProtocols[i])
            if (name.length > longest.length) {
                longest = name
            }
        }
        return longest
    }

    function updateApiProtocolState() {
        if (ServersModel.isDefaultServerFromApi) {
            root.apiAvailableProtocols = ServersModel.getDefaultServerData("apiAvailableProtocols")
            root.apiCurrentProtocol = ServersModel.getDefaultServerData("apiServiceProtocol")
        } else {
            root.apiAvailableProtocols = []
            root.apiCurrentProtocol = ""
        }
    }

    function protocolDisplayName(protocol) {
        switch (protocol) {
        case "awg": return "AWG"
        case "vless": return "VLESS"
        default: return protocol
        }
    }

    function selectProtocol(protocol) {
        if (protocol === root.apiCurrentProtocol) {
            return
        }
        if (ConnectionController.isConnectionInProgress) {
            PageController.showNotificationMessage(qsTr("Unable change protocol while trying to make an active connection"))
            return
        }
        if (ConnectionController.isConnected) {
            PageController.showNotificationMessage(qsTr("Cannot change protocol during active connection"))
            return
        }

        PageController.showBusyIndicator(true)
        ServersModel.setProcessedServerIndex(ServersModel.defaultIndex)
        ApiConfigsController.setCurrentProtocol(protocol)
        if (!ApiConfigsController.updateServiceFromGateway(ServersModel.defaultIndex, "", "", true)) {
            ApiConfigsController.setCurrentProtocol(root.apiCurrentProtocol)
        }
        root.updateApiProtocolState()
        PageController.showBusyIndicator(false)
    }

    Component.onCompleted: {
        root.updateApiProtocolState()
    }

    Connections {
        target: ServersModel

        function onDefaultServerDefaultContainerChanged() {
            root.updateApiProtocolState()
        }
    }

    TextMetrics {
        id: protocolTextMetrics

        font.family: Style.font
        font.pixelSize: 17
        font.weight: 400

        text: root.longestProtocolName
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.bottomMargin: 36
        anchors.leftMargin: 16
        anchors.rightMargin: 16

        spacing: 0

        RowLayout {
            Layout.fillWidth: true
                    
            Text {
                Layout.fillWidth: true
                lineHeight: 68
                lineHeightMode: Text.FixedHeight

                color: Style.color.gray2
                font.pixelSize: 56
                font.weight: 700
                font.family: Style.font

                horizontalAlignment: Qt.AlignLeft

                text: ConnectionController.isConnected ? qsTr("Online") : qsTr("Offline")
            }

            WhiteButtonNoBorder {
                Layout.rightMargin: -8
                Layout.topMargin: -16
                imageSource: "qrc:/images/controls/settings.svg"
                onClicked: PageController.goToPage(PageEnum.PageSettings)
            }
        }

        Item {
            Layout.fillHeight: true
        }

        XSmallTextType {
            text: qsTr("Connection to")

            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }

        RowLayout {
            DropDownType {
                id: defaultServerDropDown
                Layout.fillWidth: true

                text: ServersModel.defaultServerName

                onClicked: function() {
                    PageController.goToPage(PageEnum.PageSettingsServersList)
                }
            }

            WhiteButtonWithBorder {
                imageSource: "qrc:/images/controls/plus.svg"

                onClicked: function() {
                    PageController.goToPage(PageEnum.PageSetupWizardConfigSource)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10

            spacing: 10

            visible: ServersModel.defaultServerImagePathCollapsed !== "" || root.isApiProtocolSelectionVisible

            DropDownType {
                id: countryDropDown
                Layout.fillWidth: true

                visible: ServersModel.defaultServerImagePathCollapsed !== ""

                text: ServersModel.defaultServerDescriptionCollapsed

                onClicked: function() {
                    if (ConnectionController.isConnected) {
                        PageController.showNotificationMessage(qsTr("Unable change server location while there is an active connection"))
                        return
                    }
                    ServersModel.setProcessedServerIndex(ServersModel.defaultIndex)
                    PageController.goToPage(PageEnum.PageSettingsApiAvailableCountries)
                }
            }

            DropDownType {
                id: protocolDropDown
                Layout.fillWidth: false
                Layout.preferredWidth: Math.ceil(protocolTextMetrics.advanceWidth) + 59

                visible: root.isApiProtocolSelectionVisible
                enabled: root.apiAvailableProtocols.length > 1

                imageSource: enabled ? "qrc:/images/controls/chevron-down.svg" : ""

                text: {
                    if (root.apiCurrentProtocol.length > 0) {
                        return root.protocolDisplayName(root.apiCurrentProtocol)
                    }
                    if (root.apiAvailableProtocols.length > 0) {
                        return root.protocolDisplayName(root.apiAvailableProtocols[0])
                    }
                    return ""
                }

                onClicked: function() {
                    if (ConnectionController.isConnectionInProgress) {
                        PageController.showNotificationMessage(qsTr("Unable change protocol while trying to make an active connection"))
                        return
                    }
                    if (ConnectionController.isConnected) {
                        PageController.showNotificationMessage(qsTr("Cannot change protocol during active connection"))
                        return
                    }
                    protocolPopup.open()
                }

                Popup {
                    id: protocolPopup

                    y: protocolDropDown.height + 4
                    width: protocolDropDown.width

                    padding: 1

                    background: Rectangle {
                        color: Style.color.white
                        border.color: Style.color.gray3
                        border.width: 1
                        radius: 6
                    }

                    contentItem: ColumnLayout {
                        spacing: 0

                        Repeater {
                            model: root.apiAvailableProtocols

                            delegate: Rectangle {
                                id: protocolItem

                                required property var modelData

                                Layout.fillWidth: true
                                Layout.preferredHeight: 46

                                readonly property bool isCurrent: protocolItem.modelData === root.apiCurrentProtocol

                                color: protocolMouseArea.containsMouse ? Style.color.gray1 : Style.color.white
                                radius: 6

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16

                                    MediumTextType {
                                        Layout.fillWidth: true

                                        text: root.protocolDisplayName(protocolItem.modelData)
                                        color: Style.color.black

                                        horizontalAlignment: Qt.AlignLeft
                                        verticalAlignment: Qt.AlignVCenter
                                    }

                                    Image {
                                        Layout.preferredHeight: 22
                                        Layout.preferredWidth: 22

                                        source: "qrc:/images/controls/check.svg"
                                        visible: protocolItem.isCurrent
                                    }
                                }

                                MouseArea {
                                    id: protocolMouseArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: function() {
                                        protocolPopup.close()
                                        root.selectProtocol(protocolItem.modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Button {
            id: connectButton

            Layout.fillWidth: true
            implicitHeight: 358

            Layout.topMargin: 16

            background: Rectangle {
                anchors.fill: parent

                radius: 16

                color: {
                    if (ConnectionController.isConnectionInProgress) {
                        return Style.color.accent3
                    } else if (ConnectionController.isConnected) {
                        return Style.color.accent1
                    } else {
                        return Style.color.black
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent

                    Image {
                        Layout.alignment: Qt.AlignCenter

                        source: "qrc:/images/controls/connect-button.svg"
                    }

                    Header3TextType {
                        Layout.alignment: Qt.AlignCenter
                        Layout.topMargin: 24

                        text: ConnectionController.connectionStateText

                        color: Style.color.white
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

            onClicked: function() {
                ServersModel.setProcessedServerIndex(ServersModel.defaultIndex)
                ConnectionController.connectButtonClicked()
            }
        }
    }
}
