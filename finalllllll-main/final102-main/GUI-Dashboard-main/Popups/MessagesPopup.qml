// Messages popup for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

Popup {
    id: messagesPopup
    anchors.centerIn: parent
    width: 500
    height: 700
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
                text: "Messages"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            TextField {
                id: recipientField
                Layout.fillWidth: true
                Layout.margins: 20
                placeholderText: "Recipient"
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

            TextField {
                id: messageField
                Layout.fillWidth: true
                Layout.margins: 20
                placeholderText: "Type your message..."
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

            GridLayout {
                columns: 10
                rowSpacing: 10
                columnSpacing: 10
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.margins: 20

                Repeater {
                    model: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
                            "a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
                            "z", "x", "c", "v", "b", "n", "m", ",", ".", " ",
                            "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
                    Button {
                        width: 40
                        height: 40
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: messageField.text += modelData
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#ffffff"
                            radius: 20
                            border.color: Style.isDark ? "#616161" : "#e0e0e0"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Style.isDark ? "#ffffff" : "#424242"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Button {
                    text: "Send"
                    width: 100
                    height: 50
                    onClicked: console.log("Sending message to", recipientField.text, ":", messageField.text)
                    background: Rectangle {
                        color: "#4caf50"
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
                    text: "Backspace"
                    width: 100
                    height: 50
                    onClicked: messageField.text = messageField.text.slice(0, -1)
                    background: Rectangle {
                        color: "#ff9800"
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
                    onClicked: {
                        recipientField.text = ""
                        messageField.text = ""
                    }
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
                onClicked: messagesPopup.close()
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
