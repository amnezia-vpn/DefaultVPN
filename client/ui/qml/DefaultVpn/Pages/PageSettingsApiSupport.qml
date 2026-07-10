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

    readonly property string telegramLink: ApiAccountInfoModel.getTelegramBotLink()
    readonly property string emailLink: ApiAccountInfoModel.getEmailLink()
    readonly property string billingEmailLink: ApiAccountInfoModel.getBillingEmailLink()
    readonly property string siteName: ApiAccountInfoModel.getSiteLink()
    readonly property string siteLink: ApiAccountInfoModel.getFullSiteLink()

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        clip: true

        ColumnLayout {
            id: contentColumn

            width: parent.width
            spacing: 0

            anchors.topMargin: 8
            anchors.bottomMargin: 36
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            RowLayout {
                Layout.topMargin: 8
                Layout.leftMargin: 8

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
                Layout.topMargin: 8
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.fillWidth: true

                text: qsTr("Support")
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
            }

            MediumTextType {
                Layout.topMargin: 8
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.fillWidth: true

                text: qsTr("Our technical support specialists are available to assist you at any time")
                color: Style.color.gray7
                horizontalAlignment: Qt.AlignLeft
            }

            ColumnLayout {
                Layout.topMargin: 24
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.fillWidth: true

                spacing: 24

                ColumnLayout {
                    Layout.fillWidth: true
                    visible: root.telegramLink !== ""
                    spacing: 6

                    XSmallTextType {
                        Layout.fillWidth: true
                        text: qsTr("Telegram")
                        color: Style.color.gray7
                    }

                    MediumTextType {
                        Layout.fillWidth: true
                        text: "@" + root.telegramLink
                        color: Style.color.accent1

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally("https://t.me/" + root.telegramLink)
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    visible: root.emailLink !== ""
                    spacing: 6

                    XSmallTextType {
                        Layout.fillWidth: true
                        text: qsTr("Email")
                        color: Style.color.gray7
                    }

                    MediumTextType {
                        Layout.fillWidth: true
                        text: root.emailLink
                        color: Style.color.accent1

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally("mailto:" + root.emailLink)
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    visible: root.billingEmailLink !== ""
                    spacing: 6

                    XSmallTextType {
                        Layout.fillWidth: true
                        text: qsTr("Email Billing & Orders")
                        color: Style.color.gray7
                    }

                    MediumTextType {
                        Layout.fillWidth: true
                        text: root.billingEmailLink
                        color: Style.color.accent1

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally("mailto:" + root.billingEmailLink)
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    visible: root.siteLink !== ""
                    spacing: 6

                    XSmallTextType {
                        Layout.fillWidth: true
                        text: qsTr("Website")
                        color: Style.color.gray7
                    }

                    MediumTextType {
                        Layout.fillWidth: true
                        text: root.siteName !== "" ? root.siteName : root.siteLink
                        color: Style.color.accent1

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally(root.siteLink)
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    visible: supportTag.text !== ""
                    spacing: 6

                    XSmallTextType {
                        Layout.fillWidth: true
                        text: qsTr("Support tag")
                        color: Style.color.gray7
                    }

                    MediumTextType {
                        id: supportTag
                        Layout.fillWidth: true

                        text: SettingsController.getInstallationUuid()
                        color: Style.color.black
                        wrapMode: Text.WrapAnywhere

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                DeviceInfo.copyToClipBoard(supportTag.text)
                                PageController.showNotificationMessage(qsTr("Copied"))
                            }
                        }
                    }
                }
            }
        }
    }
}
