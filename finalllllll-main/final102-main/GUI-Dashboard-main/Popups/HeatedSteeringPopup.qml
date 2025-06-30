// Heated steering popup for controlling steering wheel heating in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: heatedSteeringPopup
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

    // Main layout for heated steering controls
    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        // Title for the heated steering popup
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            text: "Heated Steering"
            font.family: "Inter"
            font.pixelSize: 24
            font.bold: Font.Medium
            color: Style.isDark ? "#ffffff" : "#212121"
        }

        // Status text for steering heating
        Text {
            id: steeringHeatingStatusText
            Layout.alignment: Qt.AlignHCenter
            text: isHeatingOn ? "Heating: ON" : "Heating: OFF"
            font.family: "Inter"
            font.pixelSize: 18
            color: Style.isDark ? "#ffffff" : "#424242"
        }

        // Property to track heating state
        property bool isHeatingOn: false

        // Heating control button
        Button {
            text: steeringHeatingStatusText.isHeatingOn ? "Turn Off" : "Turn On"
            width: 150
            height: 50
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                steeringHeatingStatusText.isHeatingOn = !steeringHeatingStatusText.isHeatingOn
                console.log("Steering heating:", steeringHeatingStatusText.isHeatingOn ? "ON" : "OFF")
                logger.logMessage("Steering heating: " + (steeringHeatingStatusText.isHeatingOn ? "ON" : "OFF"))
            }
            background: Rectangle {
                color: steeringHeatingStatusText.isHeatingOn ? "#f44336" : "#4caf50"
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
            onClicked: heatedSteeringPopup.close()
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
