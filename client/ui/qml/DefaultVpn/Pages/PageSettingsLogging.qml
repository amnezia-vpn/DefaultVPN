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

            text: qsTr("Logging")

            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillHeight: true
        }
    }
} 