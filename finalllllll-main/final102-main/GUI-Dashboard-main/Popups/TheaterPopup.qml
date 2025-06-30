// Theater mode popup for selecting streaming services in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: theaterPopup
    anchors.centerIn: parent
    width: 400
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Background rectangle with theme-based styling
    Rectangle {
        anchors.fill: parent
        color: Style.isDark ? "#212121" : "#fafafa"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#e0e0e0"
        border.width: 1

        // Main layout for theater mode controls
        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            // Title for the theater mode popup
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Theater Mode"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            // List of streaming services
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                clip: true
                model: ["Netflix", "YouTube", "Hulu"]
                delegate: Button {
                    width: parent.width
                    height: 60
                    text: modelData
                    font.family: "Inter"
                    font.pixelSize: 18
                    // Log selection of streaming service
                    onClicked: {
                        console.log("Opening:", modelData)
                        logger.logMessage("Theater mode: " + modelData + " selected")
                    }
                    // Button background with theme-based styling
                    background: Rectangle {
                        color: Style.isDark ? "#424242" : "#ffffff"
                        radius: 10
                        border.color: Style.isDark ? "#616161" : "#e0e0e0"
                        border.width: 1
                    }
                    // Button text with theme-based color
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Style.isDark ? "#ffffff" : "#424242"
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
                onClicked: theaterPopup.close()
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
