pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Config 1.0

import "../Controls"
import "../Controls/TextTypes"

Popup {
    id: root

    property string titleText: qsTr("Title")
    property string placeholderText: ""
    property string confirmButtonText: qsTr("Save")
    property string textValue: ""
    property int maximumLength: 0
    property bool requireNonEmpty: true

    property var onConfirm

    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    anchors.centerIn: parent
    width: parent ? parent.width - 30 : 480
    padding: 24

    background: Rectangle {
        color: Style.color.white
        radius: 20
        border.width: 1
        border.color: Style.color.gray2
    }

    contentItem: ColumnLayout {
        spacing: 24

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            Header3TextType {
                Layout.fillWidth: true
                text: root.titleText
                horizontalAlignment: Text.AlignVCenter
            }

            InputType {
                id: input
                Layout.fillWidth: true
                text: root.textValue
                placeholderText: root.placeholderText
                maximumLength: root.maximumLength > 0 ? root.maximumLength : undefined
                onAccepted: {
                    const val = input.text.trim()
                    if (!root.requireNonEmpty || val !== "") {
                        if (root.onConfirm) {
                            root.onConfirm(val)
                        }
                    }
                    root.close()
                }
            }
        }

        BlueButtonNoBorder {
            Layout.fillWidth: true
            text: root.confirmButtonText
            onClicked: {
                const val = input.text.trim()
                if (!root.requireNonEmpty || val !== "") {
                    if (root.onConfirm) {
                        root.onConfirm(val)
                    }
                }
                root.close()
            }
        }
    }

    Overlay.modal: Rectangle {
        anchors.fill: parent
        color: Style.color.transparentWhite
    }
} 
