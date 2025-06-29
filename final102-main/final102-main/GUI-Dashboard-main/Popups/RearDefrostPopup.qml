// Rear defrost control popup for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: rearDefrostPopup
    anchors.centerIn: parent
    width: 400
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Property to track rear defrost state
    property bool isRearDefrostOn: false

    // Background rectangle with theme-based styling
    Rectangle {
        anchors.fill: parent
        color: Style.isDark ? "#212121" : "#fafafa"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#e0e0e0"
        border.width: 1

        // Main layout for rear defrost controls
        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            // Title for the rear defrost popup
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Rear Defrost Control"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            // Display current rear defrost state
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: rearDefrostPopup.isRearDefrostOn ? "Rear Defrost: ON" : "Rear Defrost: OFF"
                font.family: "Inter"
                font.pixelSize: 18
                color: Style.isDark ? "#ffffff" : "#424242"
            }

            // Buttons for controlling rear defrost
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                // Turn on rear defrost
                Button {
                    text: "Turn On"
                    width: 150
                    height: 50
                    enabled: !rearDefrostPopup.isRearDefrostOn
                    onClicked: {
                        rearDefrostPopup.isRearDefrostOn = true
                        console.log("Rear Defrost turned ON")
                        logger.logMessage("Rear Defrost turned ON")
                    }
                    // Button background with enabled/disabled styling
                    background: Rectangle {
                        color: enabled ? "#4caf50" : "#bdbdbd"
                        radius: 25
                    }
                    // Button text
                    contentItem: Text {
                        text: parent.text
                        font.family: "Inter"
                        font.pixelSize: 18
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // Turn off rear defrost
                Button {
                    text: "Turn Off"
                    width: 150
                    height: 50
                    enabled: rearDefrostPopup.isRearDefrostOn
                    onClicked: {
                        rearDefrostPopup.isRearDefrostOn = false
                        console.log("Rear Defrost turned OFF")
                        logger.logMessage("Rear Defrost turned OFF")
                    }
                    // Button background with enabled/disabled styling
                    background: Rectangle {
                        color: enabled ? "#f44336" : "#bdbdbd"
                        radius: 25
                    }
                    // Button text
                    contentItem: Text {
                        text: parent.text
                        font.family: "Inter"
                        font.pixelSize: 18
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Close button for the popup
            Button {
                text: "Close"
                width: 120
                height: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                onClicked: rearDefrostPopup.close()
                // Transparent background with themed border
                background: Rectangle {
                    color: "transparent"
                    border.color: Style.isDark ? "#757575" : "#bdbdbd"
                    border.width: 1
                    radius: 20
                }
                // Button text with theme-based color
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
}
