// Bluetooth popup for managing device connections in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

// Bluetooth devices popup
Popup {
    id: bluetoothPopup
    anchors.centerIn: parent
    width: 400
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Rectangle {
        anchors.fill: parent
        color: Style.isDark ? "#212121" : "#00BFFF"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#00BFFF"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Bluetooth Devices"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#00BFFF" : "#212121"
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                clip: true
                model: ["Phone", "Headphones", "Car Audio"]
                delegate: Button {
                    width: parent.width
                    height: 60
                    text: modelData
                    font.family: "Inter"
                    font.pixelSize: 18
                    onClicked: {
                        console.log("Selected:", modelData)
                        logger.logMessage("Bluetooth: " + modelData + " selected")
                        if (modelData === "Phone") {
                            phoneSubMenuPopup.open()
                        } else if (modelData === "Headphones") {
                            headphonesSubMenuPopup.open()
                        } else if (modelData === "Car Audio") {
                            carAudioSubMenuPopup.open()
                        }
                    }
                    background: Rectangle {
                        color: Style.isDark ? "#424242" : "#00BFFF"
                        radius: 10
                        border.color: Style.isDark ? "#616161" : "#00BFFF"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Style.isDark ? "#00BFFF" : "#424242"
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
                onClicked: bluetoothPopup.close()
                background: Rectangle {
                    color: "transparent"
                    border.color: Style.isDark ? "#757575" : "#00BFFF"
                    border.width: 1
                    radius: 20
                }
                contentItem: Text {
                    text: parent.text
                    font.family: "Inter"
                    font.pixelSize: 16
                    color: Style.isDark ? "#00BFFF" : "#616161"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // Sub-menu popup for Phone options
    Popup {
        id: phoneSubMenuPopup
        anchors.centerIn: parent
        width: 300
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Rectangle {
            anchors.fill: parent
            color: Style.isDark ? "#212121" : "#00BFFF"
            radius: 20
            border.color: Style.isDark ? "#424242" : "#00BFFF"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    text: "Phone Options"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#00BFFF" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["Search for Phones", "Connect to Phone"]
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: {
                            console.log("Phone option selected:", modelData)
                            logger.logMessage("Bluetooth Phone: " + modelData + " selected")
                            if (modelData === "Search for Phones") {
                                console.log("Initiating phone search")
                                logger.logMessage("Bluetooth: Initiating phone search")
                            } else if (modelData === "Connect to Phone") {
                                console.log("Connecting to phone")
                                logger.logMessage("Bluetooth: Connecting to phone")
                            }
                            phoneSubMenuPopup.close()
                        }
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#00BFFF"
                            radius: 10
                            border.color: Style.isDark ? "#616161" : "#00BFFF"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Style.isDark ? "#00BFFF" : "#424242"
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
                    onClicked: phoneSubMenuPopup.close()
                    background: Rectangle {
                        color: "transparent"
                        border.color: Style.isDark ? "#757575" : "#00BFFF"
                        border.width: 1
                        radius: 20
                    }
                    contentItem: Text {
                        text: parent.text
                        font.family: "Inter"
                        font.pixelSize: 16
                        color: Style.isDark ? "#00BFFF" : "#616161"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    // Sub-menu popup for Headphones options
    Popup {
        id: headphonesSubMenuPopup
        anchors.centerIn: parent
        width: 300
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Rectangle {
            anchors.fill: parent
            color: Style.isDark ? "#212121" : "#00BFFF"
            radius: 20
            border.color: Style.isDark ? "#424242" : "#00BFFF"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    text: "Headphones Options"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ?"#00BFFF" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["Pair New Headphones", "Connect to Headphones"]
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: {
                            console.log("Headphones option selected:", modelData)
                            logger.logMessage("Bluetooth Headphones: " + modelData + " selected")
                            if (modelData === "Pair New Headphones") {
                                console.log("Initiating headphones pairing")
                                logger.logMessage("Bluetooth: Initiating headphones pairing")
                            } else if (modelData === "Connect to Headphones") {
                                console.log("Connecting to headphones")
                                logger.logMessage("Bluetooth: Connecting to headphones")
                            }
                            headphonesSubMenuPopup.close()
                        }
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#00BFFF"
                            radius: 10
                            border.color: Style.isDark ? "#616161" : "#00BFFF"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Style.isDark ? "#00BFFF" : "#424242"
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
                    onClicked: headphonesSubMenuPopup.close()
                    background: Rectangle {
                        color: "transparent"
                        border.color: Style.isDark ? "#757575" : "#00BFFF"
                        border.width: 1
                        radius: 20
                    }
                    contentItem: Text {
                        text: parent.text
                        font.family: "Inter"
                        font.pixelSize: 16
                        color: Style.isDark ? "#00BFFF" : "#616161"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    // Sub-menu popup for Car Audio options
    Popup {
        id: carAudioSubMenuPopup
        anchors.centerIn: parent
        width: 300
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Rectangle {
            anchors.fill: parent
            color: Style.isDark ? "#212121" : "#00BFFF"
            radius: 20
            border.color: Style.isDark ? "#424242" : "#00BFFF"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    text: "Car Audio Options"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#00BFFF" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["Configure Audio Settings", "Connect to Car Audio"]
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: {
                            console.log("Car Audio option selected:", modelData)
                            logger.logMessage("Bluetooth Car Audio: " + modelData + " selected")
                            if (modelData === "Configure Audio Settings") {
                                console.log("Opening car audio settings")
                                logger.logMessage("Bluetooth: Opening car audio settings")
                            } else if (modelData === "Connect to Car Audio") {
                                console.log("Connecting to car audio")
                                logger.logMessage("Bluetooth: Connecting to car audio")
                            }
                            carAudioSubMenuPopup.close()
                        }
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#00BFFF"
                            radius: 10
                            border.color: Style.isDark ? "#616161" : "#00BFFF"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Style.isDark ? "#00BFFF" : "#424242"
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
                    onClicked: carAudioSubMenuPopup.close()
                    background: Rectangle {
                        color: "transparent"
                        border.color: Style.isDark ? "#757575" : "#00BFFF"
                        border.width: 1
                        radius: 20
                    }
                    contentItem: Text {
                        text: parent.text
                        font.family: "Inter"
                        font.pixelSize: 16
                        color: Style.isDark ? "#00BFFF" : "#616161"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
