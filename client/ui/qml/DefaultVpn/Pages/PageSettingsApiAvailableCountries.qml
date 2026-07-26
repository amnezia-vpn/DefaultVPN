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

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8

            WhiteButtonNoBorder {
                id: backButton
                imageSource: "qrc:/images/controls/arrow-left.svg"
                
                onClicked: PageController.closePage()
            }
        }

        Header1TextType {
            Layout.topMargin: 8
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.fillWidth: true

            text: qsTr("Amnezia Premium servers")

            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }

        Rectangle {
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.fillWidth: true
            implicitHeight: 44
            radius: 8

            color: Style.color.white
            border.width: 1
            border.color: searchField.activeFocus ? Style.color.accent1 : Style.color.gray3

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 6
                spacing: 8

                Image {
                    width: 18
                    height: 18
                    source: "qrc:/images/controls/search.svg"
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true

                    background: Item {}
                    placeholderText: qsTr("country or country code")
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                    font.pixelSize: 16
                    font.weight: 400
                    font.family: Style.font
                    color: Style.color.black
                    topPadding: 0
                    bottomPadding: 0
                    leftPadding: 0
                    rightPadding: 0
                    verticalAlignment: TextInput.AlignVCenter

                    onTextChanged: ApiCountryModel.searchText = text
                    Keys.onEscapePressed: searchField.text = ""

                    ContextMenu.menu: ContextMenuType {
                        textObj: searchField
                    }
                }

                ButtonType {
                    visible: searchField.text !== ""
                    implicitWidth: 32
                    implicitHeight: 32
                    imageSource: "qrc:/images/controls/close.svg"
                    defaultBackgroundColor: Style.color.transparent
                    hoveredBackgroundColor: Style.color.gray1
                    pressedBackgroundColor: Style.color.gray2

                    onClicked: searchField.text = ""
                }
            }
        }

        ButtonGroup {
            id: countriesRadioButtonGroup
        }

        ListView {
            id: countriesListView

            Layout.topMargin: 16
            Layout.fillHeight: true
            Layout.fillWidth: true

            model: ApiCountryModel.regionRowsModel

            ScrollBar.vertical: ScrollBar {}

            footer: Item {
                width: countriesListView.width
                height: ApiCountryModel.hasVisibleRegions ? 0 : noResultsText.implicitHeight + 32

                XSmallTextType {
                    id: noResultsText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    visible: !ApiCountryModel.hasVisibleRegions
                    text: qsTr("Nothing found. Try a different spelling or switch keyboard layout.")
                    color: Style.color.gray9
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignTop
                    wrapMode: Text.WordWrap
                }
            }

            delegate: Item {
                required property string rowType
                required property string regionName
                required property bool isExpanded
                required property int sourceIndex
                required property string countryName
                required property string countryCode
                required property string countryImageCode
                required property string sourceCountryName

                implicitWidth: countriesListView.width
                implicitHeight: rowType === "region" ? 42 : countryItem.implicitHeight

                Item {
                    anchors.fill: parent
                    visible: rowType === "region"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        anchors.topMargin: 10
                        anchors.bottomMargin: 6
                        spacing: 8

                        XSmallTextType {
                            Layout.fillWidth: true
                            text: regionName
                            color: Style.color.gray9
                            horizontalAlignment: Qt.AlignLeft
                            verticalAlignment: Qt.AlignVCenter
                        }

                        Image {
                            source: isExpanded ? "qrc:/images/controls/chevron-up.svg"
                                               : "qrc:/images/controls/chevron-down.svg"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ApiCountryModel.toggleRegionExpanded(regionName)
                    }
                }

                RadioButton {
                    id: countryItem

                    anchors.fill: parent
                    anchors.rightMargin: 16
                    anchors.leftMargin: 16
                    visible: rowType === "country"

                    ButtonGroup.group: countriesRadioButtonGroup

                    checked: sourceIndex >= 0 && sourceIndex === ApiCountryModel.currentIndex

                    indicator: Item { }

                    contentItem: Item {
                        id: contentContainer

                        anchors.left: parent.left
                        anchors.right: parent.right

                        implicitHeight: content.implicitHeight

                        Rectangle {
                            anchors.fill: parent
                            radius: 8
                            color: countryItem.checked ? Style.color.gray1 : Style.color.transparent
                        }

                        RowLayout {
                            id: content
                            anchors.fill: parent

                            Header3TextType {
                                Layout.fillWidth: true
                                Layout.leftMargin: 8
                                Layout.topMargin: 19
                                Layout.bottomMargin: 19

                                text: countryName

                                color: countryItem.hovered ? Style.color.gray9 : Style.color.black
                            }

                            Image {
                                Layout.rightMargin: 8
                                width: 32
                                height: 24
                                source: "qrc:/countriesFlags/images/flagKit/" + countryImageCode + ".svg"
                            }
                        }
                    }

                    onClicked: function() {
                        if (ConnectionController.isConnectionInProgress) {
                            PageController.showNotificationMessage(qsTr("Unable change server location while trying to make an active connection"))
                            return
                        }
                        if (ConnectionController.isConnected) {
                            PageController.showNotificationMessage(qsTr("Unable change server location while there is an active connection"))
                            return
                        }

                        if (sourceIndex !== ApiCountryModel.currentIndex) {
                            PageController.showBusyIndicator(true)
                            var prevIndex = ApiCountryModel.currentIndex
                            ApiCountryModel.currentIndex = sourceIndex
                            if (!ApiConfigsController.updateServiceFromGateway(ServersModel.defaultIndex, countryCode, sourceCountryName)) {
                                ApiCountryModel.currentIndex = prevIndex
                            }
                            PageController.showBusyIndicator(false)
                            PageController.closePage()
                        }
                    }

                    MouseArea {
                        anchors.fill: countryItem
                        cursorShape: Qt.PointingHandCursor
                        enabled: false
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.bottom: parent.bottom
                    height: 1
                    color: Style.color.gray3
                    visible: rowType === "country"
                }
            }
        }
    }
}
