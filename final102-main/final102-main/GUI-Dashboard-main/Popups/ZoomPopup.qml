// Zoom meeting popup for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: zoomPopup
    anchors.centerIn: parent
    width: 400
    height: 400
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Rectangle {
        anchors.fill: parent
        color: Style.isDark ? "#212121" : "#fafafa"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#e0e0e0"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Zoom Meeting"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            TextField {
                id: meetingLink
                Layout.fillWidth: true
                Layout.margins: 20
                placeholderText: "Enter meeting link"
                font.family: "Inter"
                font.pixelSize: 18
                color: Style.isDark ? "#ffffff" : "#424242"
                background: Rectangle {
                    color: Style.isDark ? "#424242" : "#ffffff"
                    radius: 10
                    border.color: Style.isDark ? "#616161" : "#e0e0e0"
                    border.width: 1
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    text: "Join Meeting"
                    width: 150
                    height: 50
                    onClicked: console.log("Joining Zoom meeting:", meetingLink.text)
                    background: Rectangle {
                        color: "#2196f3"
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

                Button {
                    text: "Clear"
                    width: 100
                    height: 50
                    onClicked: meetingLink.text = ""
                    background: Rectangle {
                        color: "#f44336"
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

            Button {
                text: "Close"
                width: 120
                height: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                onClicked: zoomPopup.close()
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
}
