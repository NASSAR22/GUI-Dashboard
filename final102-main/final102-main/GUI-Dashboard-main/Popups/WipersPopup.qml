// Windshield wiper control popup for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: wipersPopup
    anchors.centerIn: parent
    width: 400
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Property to track wiper state
    property bool areWipersOn: false

    // Background rectangle with theme-based styling
    Rectangle {
        anchors.fill: parent
        color: Style.isDark ? "#212121" : "#fafafa"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#e0e0e0"
        border.width: 1

        // Main layout for wiper controls
        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            // Title for the wiper popup
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Wiper Control"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            // Display current wiper state
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: wipersPopup.areWipersOn ? "Wipers: ON" : "Wipers: OFF"
                font.family: "Inter"
                font.pixelSize: 18
                color: Style.isDark ? "#ffffff" : "#424242"
            }

            // Buttons for controlling wipers
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                // Turn on wipers
                Button {
                    text: "Turn On"
                    width: 150
                    height: 50
                    enabled: !wipersPopup.areWipersOn
                    onClicked: {
                        wipersPopup.areWipersOn = true
                        console.log("Wipers turned ON")
                        logger.logMessage("Wipers turned ON")
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

                // Turn off wipers
                Button {
                    text: "Turn Off"
                    width: 150
                    height: 50
                    enabled: wipersPopup.areWipersOn
                    onClicked: {
                        wipersPopup.areWipersOn = false
                        console.log("Wipers turned OFF")
                        logger.logMessage("Wipers turned OFF")
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
                onClicked: wipersPopup.close()
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
