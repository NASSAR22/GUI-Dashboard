// Front defrost popup for controlling front windshield defrost in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: frontDefrostPopup
    anchors.centerIn: parent
    width: 400
    height: 400
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 0

    // Animation for entering the popup
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200 }
    }

    // Animation for exiting the popup
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
    }

    // Background rectangle with theme-based styling
    background: Rectangle {
        color: Style.isDark ? "#212121" : "#fafafa"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#e0e0e0"
        border.width: 1
    }

    // Main layout for front defrost controls
    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        // Title for the front defrost popup
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            text: "Front Defrost"
            font.family: "Inter"
            font.pixelSize: 24
            font.bold: Font.Medium
            color: Style.isDark ? "#ffffff" : "#212121"
        }

        // Status text for defrost
        Text {
            id: defrostStatusText
            Layout.alignment: Qt.AlignHCenter
            text: isDefrostOn ? "Defrost: ON" : "Defrost: OFF"
            font.family: "Inter"
            font.pixelSize: 18
            color: Style.isDark ? "#ffffff" : "#424242"
        }

        // Property to track defrost state
        property bool isDefrostOn: false

        // Defrost control button
        Button {
            text: defrostStatusText.isDefrostOn ? "Turn Off" : "Turn On"
            width: 150
            height: 50
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                defrostStatusText.isDefrostOn = !defrostStatusText.isDefrostOn
                console.log("Front defrost:", defrostStatusText.isDefrostOn ? "ON" : "OFF")
                logger.logMessage("Front defrost: " + (defrostStatusText.isDefrostOn ? "ON" : "OFF"))
            }
            background: Rectangle {
                color: defrostStatusText.isDefrostOn ? "#f44336" : "#4caf50"
                radius: 25
            }
            contentItem: Text {
                text: parent.text
                font.family: "Inter"
                font.pixelSize: 18
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Close button
        Button {
            text: "Close"
            width: 120
            height: 40
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
            onClicked: frontDefrostPopup.close()
            background: Rectangle {
                color: "transparent"
                border.color: Style.isDark ? "#757575" : "#bdbdbd"
                border.width: 1
                radius: 20
            }
            contentItem: Text {
                text: parent.text
                font.family: "Inter"
                font.pixelSize: 16
                color: Style.isDark ? "#ffffff" : "#616161"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
