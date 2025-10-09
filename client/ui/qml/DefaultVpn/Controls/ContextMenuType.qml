import QtQuick
import QtQuick.Controls

Menu {
    property var textObj

    popupType: Popup.Native

    MenuItem {
        text: qsTr("C&ut")
        enabled: textObj.selectedText
        onTriggered: textObj.cut()
    }
    MenuItem {
        text: qsTr("&Copy")
        enabled: textObj.selectedText
        onTriggered: textObj.copy()
    }
    MenuItem {
        text: qsTr("&Paste")
        // Fix calling paste from clipboard when launching app on android/ios
        enabled: (Qt.platform.os === "android" || Qt.platform.os === "ios") ? true : textObj.canPaste
        onTriggered: textObj.paste()
    }

    MenuItem {
        text: qsTr("&SelectAll")
        enabled: textObj.length > 0
        onTriggered: textObj.selectAll()
    }
}
