import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.15
import "Components"
import "qrc:/LayoutManager.js" as Responsive

ApplicationWindow {
    id: root
    width: 1920
    height: 1200
    visible: true
    title: qsTr("Tesla Screen")
    onWidthChanged: {
        if(adaptive)
            adaptive.updateWindowWidth(root.width)
    }

    onHeightChanged: {
        if(adaptive)
            adaptive.updateWindowHeight(root.height)
    }
    property var adaptive: new Responsive.AdaptiveLayoutManager(root.width, root.height, root.width, root.height)

    FontLoader {
        id: uniTextFont
        source: "qrc:/Fonts/Unitext Regular.ttf"
    }

    background: Loader {
        anchors.fill: parent
        sourceComponent: Style.mapAreaVisible ? backgroundRect : backgroundImage
    }

    Header {
        z: 99
        id: headerLayout
    }

    footer: Footer {
        id: footerLayout
        onOpenLauncher: launcher.open()
        onPhoneClicked: phonePopup.open()
        onBluetoothClicked: bluetoothPopup.open()
        onRadioClicked: radioPopup.open()
        onSpotifyClicked: spotifyPopup.open()
        onDashcamClicked: dashcamPopup.open()
        onTuneinClicked: tuneinPopup.open()
        onMusicClicked: musicPopup.open()
        onCalendarClicked: calendarPopup.open()
        onZoomClicked: zoomPopup.open()
        onMessagesClicked: messagesPopup.open()
    }

    TopLeftButtonIconColumn {
        z: 99
        anchors.left: parent.left
        anchors.top: headerLayout.bottom
        anchors.leftMargin: 18
    }

    RowLayout {
        id: mapLayout
        visible: Style.mapAreaVisible
        spacing: 0
        anchors.fill: parent
        Item {
            Layout.preferredWidth: 620
            Layout.fillHeight: true
            Image {
                anchors.centerIn: parent
                source: Style.isDark ? "qrc:/icons/light/sidebar.png" : "qrc:/icons/dark/sidebar-light.png"
            }
        }

        NavigationMapHelperScreen {
            Layout.fillWidth: true
            Layout.fillHeight: true
            runMenuAnimation: true
        }
    }

    LaunchPadControl {
        id: launcher
        y: (root.height - height) / 2 + (footerLayout.height)
        x: (root.width - width ) / 2
    }

    Component {
        id: backgroundRect
        Rectangle {
            color: "#171717"
            anchors.fill: parent
        }
    }

    Component {
        id: backgroundImage
        Image {
            source: Style.getImageBasedOnTheme()
            Icon {
                icon.source: Style.isDark ? "qrc:/icons/car_action_icons/dark/lock.svg" : "qrc:/icons/car_action_icons/lock.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -350
                anchors.horizontalCenterOffset: 37
            }

            Icon {
                icon.source: Style.isDark ? "qrc:/icons/car_action_icons/dark/Power.svg" : "qrc:/icons/car_action_icons/Power.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -77
                anchors.horizontalCenterOffset: 550
            }

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -230
                anchors.horizontalCenterOffset: 440

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Trunk"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.bold: Font.DemiBold
                    color: Style.black20
                }
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Open"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.bold: Font.Bold
                    color: Style.isDark ? Style.white : "#171717"
                }
            }

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -180
                anchors.horizontalCenterOffset: -350

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Frunk"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.bold: Font.DemiBold
                    color: Style.black20
                }
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Open"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.bold: Font.Bold
                    color: Style.isDark ? Style.white : "#171717"
                }
            }
        }
    }

    // Popup for Phone (Dialer)
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
                        onClicked: console.log("Calling:", dialedNumber.text)
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

    // Popup for Bluetooth (Device List)
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
                    text: "Bluetooth Devices"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["Phone", "Headphones", "Car Audio"] // Example devices
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: console.log("Connecting to:", modelData)
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

    // Popup for Radio (Station Selector)
    Popup {
        id: radioPopup
        anchors.centerIn: parent
        width: 400
        height: 500
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
                    text: "Radio Stations"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["FM 90.5", "FM 94.3", "FM 102.7"] // Example stations
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: console.log("Tuning to:", modelData)
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
                        }
                    }
                }

                Button {
                    text: "Close"
                    width: 120
                    height: 40
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20
                    onClicked: radioPopup.close()
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

    // Popup for Spotify (Playlist Selector)
    Popup {
        id: spotifyPopup
        anchors.centerIn: parent
        width: 400
        height: 500
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
                    text: "Spotify Playlists"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["Chill Hits", "Rock Classics", "Pop Vibes"] // Example playlists
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: console.log("Playing:", modelData)
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
                        }
                    }
                }

                Button {
                    text: "Close"
                    width: 120
                    height: 40
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20
                    onClicked: spotifyPopup.close()
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

    // Popup for Dashcam (Control Buttons)
    Popup {
        id: dashcamPopup
        anchors.centerIn: parent
        width: 400
        height: 300
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
                    text: "Dashcam Control"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Button {
                        text: "Start Recording"
                        width: 150
                        height: 50
                        onClicked: console.log("Dashcam recording started")
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
                        text: "Stop Recording"
                        width: 150
                        height: 50
                        onClicked: console.log("Dashcam recording stopped")
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
    }

    // Popup for TuneIn (Station Selector)
    Popup {
        id: tuneinPopup
        anchors.centerIn: parent
        width: 400
        height: 500
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
                    text: "TuneIn Stations"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    model: ["BBC Radio", "NPR", "Jazz FM"] // Example stations
                    delegate: Button {
                        width: parent.width
                        height: 60
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 18
                        onClicked: console.log("Tuning to:", modelData)
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
                        }
                    }
                }

                Button {
                    text: "Close"
                    width: 120
                    height: 40
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20
                    onClicked: tuneinPopup.close()
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

    // Popup for Music (Player Controls)
    Popup {
        id: musicPopup
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
                    text: "Music Player"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Now Playing: Song Title"
                    font.family: "Inter"
                    font.pixelSize: 18
                    color: Style.isDark ? "#ffffff" : "#424242"
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Button {
                        text: "◄◄"
                        width: 60
                        height: 60
                        onClicked: console.log("Previous track")
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#ffffff"
                            radius: 30
                            border.color: Style.isDark ? "#616161" : "#e0e0e0"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            font.family: "Inter"
                            font.pixelSize: 20
                            color: Style.isDark ? "#ffffff" : "#424242"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Button {
                        text: "▶"
                        width: 80
                        height: 80
                        onClicked: console.log("Play/Pause")
                        background: Rectangle {
                            color: "#4caf50"
                            radius: 40
                        }
                        contentItem: Text {
                            text: parent.text
                            font.family: "Inter"
                            font.pixelSize: 30
                            color: "#ffffff"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Button {
                        text: "►►"
                        width: 60
                        height: 60
                        onClicked: console.log("Next track")
                        background: Rectangle {
                            color: Style.isDark ? "#424242" : "#ffffff"
                            radius: 30
                            border.color: Style.isDark ? "#616161" : "#e0e0e0"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            font.family: "Inter"
                            font.pixelSize: 20
                            color: Style.isDark ? "#ffffff" : "#424242"
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
                    onClicked: musicPopup.close()
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

    // Popup for Calendar (Detailed with Months and Years)
    Popup {
        id: calendarPopup
        anchors.centerIn: parent
        width: 500
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
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    text: "Calendar"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: Font.Medium
                    color: Style.isDark ? "#ffffff" : "#212121"
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    ComboBox {
                        id: monthSelector
                        width: 150
                        model: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                        currentIndex: 2 // Default to March (since current date is March 16, 2025)
                        font.family: "Inter"
                        font.pixelSize: 18
                        onCurrentIndexChanged: updateDays()
                    }

                    ComboBox {
                        id: yearSelector
                        width: 100
                        model: ListModel {
                            id: yearModel
                        }
                        currentIndex: 0 // Default to 2025
                        font.family: "Inter"
                        font.pixelSize: 18
                        Component.onCompleted: {
                            for (var i = 2020; i <= 2030; i++) {
                                yearModel.append({ "text": i })
                            }
                            currentIndex = 5 // Set to 2025
                        }
                        onCurrentIndexChanged: updateDays()
                    }
                }

                GridLayout {
                    id: daysGrid
                    columns: 7
                    rowSpacing: 10
                    columnSpacing: 10
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 20

                    function updateDays() {
                        daysRepeater.model = 0 // Reset model
                        var daysInMonth = [31, (yearSelector.currentText % 4 === 0 && yearSelector.currentText % 100 !== 0) || (yearSelector.currentText % 400 === 0) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
                        daysRepeater.model = daysInMonth[monthSelector.currentIndex]
                    }

                    Repeater {
                        id: daysRepeater
                        model: 31 // Default to 31 days (updated by updateDays)
                        Button {
                            width: 50
                            height: 50
                            text: index + 1
                            font.family: "Inter"
                            font.pixelSize: 18
                            onClicked: console.log("Selected date:", monthSelector.currentText, text, yearSelector.currentText)
                            background: Rectangle {
                                color: Style.isDark ? "#424242" : "#ffffff"
                                radius: 25
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

                Button {
                    text: "Close"
                    width: 120
                    height: 40
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20
                    onClicked: calendarPopup.close()
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
            Component.onCompleted: daysGrid.updateDays() // Initialize days on load
        }
    }

    // Popup for Zoom (Meeting Interface)
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

    // Popup for Messages (Messaging Interface with Keyboard)
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
}
