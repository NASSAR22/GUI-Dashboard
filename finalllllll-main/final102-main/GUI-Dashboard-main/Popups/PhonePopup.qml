// Phone popup for managing calls in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

// Phone dialer popup
Popup {
    id: phonePopup
    anchors.centerIn: parent
    width: 400
    height: 600
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
                id: dialedNumber
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                text: ""
                font.family: "Inter"
                font.pixelSize: 36
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            GridLayout {
                columns: 3
                rowSpacing: 15
                columnSpacing: 15
                Layout.alignment: Qt.AlignHCenter

                Repeater {
                    model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
                    Button {
                        width: 80
                        height: 80
                        text: modelData
                        font.pixelSize: 28
                        font.family: "Inter"
                        onClicked: dialedNumber.text += modelData
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#ffffff"
                            radius: 40
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
                Layout.bottomMargin: 20
                spacing: 10

                Button {
                    text: "Call"
                    width: 100
                    height: 50
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
                    onClicked: {
                        logger.logMessage("Calling number: " + dialedNumber.text)
                        console.log("Call initiated")
                    }
                }

                Button {
                    text: "Backspace"
                    width: 100
                    height: 50
                    onClicked: dialedNumber.text = dialedNumber.text.slice(0, -1)
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
                    onClicked: dialedNumber.text = ""
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
                onClicked: phonePopup.close()
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
