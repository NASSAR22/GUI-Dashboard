// Dashcam popup for managing camera recordings in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: dashcamPopup
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

    // Main layout for dashcam controls
    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        // Title for the dashcam popup
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            text: "Dashcam"
            font.family: "Inter"
            font.pixelSize: 24
            font.bold: Font.Medium
            color: Style.isDark ? "#ffffff" : "#212121"
        }

        // Status text for dashcam
        Text {
            id: dashcamStatusText
            Layout.alignment: Qt.AlignHCenter
            text: isRecording ? "Recording: ON" : "Recording: OFF"
            font.family: "Inter"
            font.pixelSize: 18
            color: Style.isDark ? "#ffffff" : "#424242"
        }

        // Property to track recording state
        property bool isRecording: false

        // List of recorded clips (placeholder)
        ListView {
            id: dashcamClipsListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            clip: true
            model: ListModel {
                ListElement { clipName: "Clip 1 - 2025-06-28 10:00"; duration: "5:30" }
                ListElement { clipName: "Clip 2 - 2025-06-28 12:15"; duration: "3:45" }
            }
            delegate: Button {
                width: parent.width
                height: 60
                text: clipName + " (" + duration + ")"
                font.family: "Inter"
                font.pixelSize: 18
                onClicked: {
                    console.log("Playing dashcam clip:", clipName)
                    logger.logMessage("Dashcam: Playing clip " + clipName)
                }
                background: Rectangle {
                    color: Style.isDark ? "#424242" : "#ffffff"
                    radius: 10
                    border.color: Style.isDark ? "#616161" : "#e0e0e0"
                    border.width: 1
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: Style.isDark ? "#ffffff" : "#424242"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
            ScrollBar.vertical: ScrollBar {}
        }

        // Recording control buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            // Start/Stop recording button
            Button {
                text: dashcamStatusText.isRecording ? "Stop Recording" : "Start Recording"
                width: 150
                height: 50
                onClicked: {
                    dashcamStatusText.isRecording = !dashcamStatusText.isRecording
                    console.log("Dashcam recording:", dashcamStatusText.isRecording ? "Started" : "Stopped")
                    logger.logMessage("Dashcam recording: " + (dashcamStatusText.isRecording ? "Started" : "Stopped"))
                }
                background: Rectangle {
                    color: dashcamStatusText.isRecording ? "#f44336" : "#4caf50"
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
        }

        // Close button
        Button {
            text: "Close"
            width: 120
            height: 40
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
            onClicked: dashcamPopup.close()
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
