import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15
import Style 1.0
import QtGraphicalEffects 1.15
import "Components"
import "Utils"
import "Popups"
import "qrc:/LayoutManager.js" as Responsive

ApplicationWindow {
    id: root
    property var logger: Logger
    property var theme: Style
    property bool isFrunkOpen: false
    property bool isTrunkOpen: false
    property bool isLocked: false
    property bool isCharging: false

    width: 1920
    height: 1200
    visible: true
    title: qsTr("Tesla Screen")

    FontLoader {
        id: uniTextFont
        source: "qrc:/Fonts/Unitext Regular.ttf"
    }

    // Background rectangle component
    Component {
        id: backgroundRect
        Rectangle {
            color: "#171717"
            anchors.fill: parent
        }
    }

    // Background image with control buttons
    Component {
        id: backgroundImage
        Image {
            source: theme.getImageBasedOnTheme()

            // Lock button to toggle the locked state of the vehicle
            Button {
                id: lockButton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -350
                    horizontalCenterOffset: 37
                }
                width: 100
                height: 100
                // Icon changes based on lock state and theme
                icon.source: theme.isDark ? "qrc:/icons/car_action_icons/dark/lock.svg" : "qrc:/icons/car_action_icons/lock.svg"
                icon.color: root.isLocked ? "#ff0000" : "#00ff00"
                icon.width: 80
                icon.height: 80
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    // Toggle the locked state
                    root.isLocked = !root.isLocked;



                    // Log lock state and statuses
                    logger.logMessage("Vehicle " + (root.isLocked ? "locked" : "unlocked") +
                                      ", Frunk: " + (root.isFrunkOpen ? "open" : "closed") +
                                      ", Trunk: " + (root.isTrunkOpen ? "open" : "closed") +
                                      ", Charging: " + (root.isCharging ? "on" : "off"));
                    console.log("Vehicle " + (root.isLocked ? "locked" : "unlocked") +
                                ", Charging: " + (root.isCharging ? "on" : "off"));
                }
            }

            // Button to control vehicle lights
            Button {
                id: lightsButton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -250
                    horizontalCenterOffset: -150
                }
                // Icon and color change based on light status
                icon.source: theme.isDark ? "qrc:/icons/car_action_icons/dark/lights.svg" : "qrc:/icons/car_action_icons/lights.svg"
                icon.color: isLightsOn ? "#00ff00" : "#ff0000"
                background: Rectangle {
                    color: "transparent"
                }
                property bool isLightsOn: false
                onClicked: {
                    // Toggle lights on and off
                    isLightsOn = !isLightsOn
                    logger.logMessage("Lights " + (isLightsOn ? "turned ON" : "turned OFF"))
                    console.log("Lights " + (isLightsOn ? "turned ON" : "turned OFF"))
                    forceActiveFocus()
                    root.update()
                }
            }

            // Button to control vehicle charging
            Button {
                id: chargeButton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -80
                    horizontalCenterOffset: 550
                }
                width: 80
                height: 80
                // Icon and color change based on charging status
                icon.source: theme.isDark ? "qrc:/icons/car_action_icons/Power.svg" : "qrc:/icons/car_action_icons/charge.svg"
                icon.width: 50
                icon.height: 50
                icon.color: root.isCharging ? "#00ff00" : "#ff0000"
                enabled: !root.isLocked // Disabled when vehicle is locked
                background: null
                onClicked: {
                    if (!root.isLocked) {
                        // Toggle charging state
                        root.isCharging = !root.isCharging
                        logger.logMessage("Charge " + (root.isCharging ? "started" : "stopped"))
                        console.log("Charge " + (root.isCharging ? "started" : "stopped") + " at " + new Date().toLocaleTimeString())
                    } else {
                        // Prevent action when locked
                        logger.logMessage("Cannot toggle charging while vehicle is locked")
                        console.log("Cannot toggle charging while vehicle is locked")
                    }
                }
            }

            // Layout for controlling the trunk
            ColumnLayout {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -230
                    horizontalCenterOffset: 440
                }
                Loader {
                    sourceComponent: controlLayoutComponent
                    property string title: "Trunk"
                    property bool isOpen: isTrunkOpen
                    property color openColor: "#ff0000"
                    property color closeColor: "#00ff00"
                    property var onToggle: function() {
                        // Toggle trunk open/close state
                        isTrunkOpen = !isTrunkOpen
                        forceActiveFocus()
                        root.update()
                        logger.logMessage("Trunk " + (isTrunkOpen ? "opened" : "closed"))
                        console.log("Trunk " + (isTrunkOpen ? "opened" : "closed"))
                    }
                }
            }

            // Layout for controlling the frunk
            ColumnLayout {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -180
                    horizontalCenterOffset: -350
                }
                Loader {
                    sourceComponent: controlLayoutComponent
                    property string title: "Frunk"
                    property bool isOpen: isFrunkOpen
                    property color openColor: "#ff0000"
                    property color closeColor: "#00ff00"
                    property var onToggle: function() {
                        // Toggle frunk open/close state
                        isFrunkOpen = !isFrunkOpen
                        forceActiveFocus()
                        root.update()
                        logger.logMessage("Frunk " + (isFrunkOpen ? "opened" : "closed"))
                        console.log("Frunk " + (isFrunkOpen ? "opened" : "closed"))
                    }
                }
            }
        }
    }

    // Component for reusable control layouts (trunk/frunk)
    Component {
        id: controlLayoutComponent
        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            // Text displaying the title of the control
            Text {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                text: title
                font {
                    family: "Inter"
                    pixelSize: 14
                    bold: Font.DemiBold
                }
                color: theme.black20
            }

            // Button to toggle open/close state
            Button {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                text: isOpen ? "Close" : "Open"
                font {
                    family: "Inter"
                    pixelSize: 16
                    bold: Font.Bold
                }
                enabled: !root.isLocked // Disabled when vehicle is locked
                onClicked: {
                    // Call toggle function
                    onToggle()
                    logger.logMessage(title + (isOpen ? " opened" : " closed"))
                    console.log(title + (isOpen ? " opened" : " closed"))
                }

                background: Rectangle {
                    color: isOpen ? openColor : closeColor
                    radius: 10
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: theme.isDark ? theme.white : "#171717"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    background: Loader {
        anchors.fill: parent
        sourceComponent: theme.mapAreaVisible ? backgroundRect : backgroundImage
        Component.onCompleted: console.log("Loaded component: " + (theme.mapAreaVisible ? "backgroundRect" : "backgroundImage"))
        Connections {
            target: theme
            function onMapAreaVisibleChanged() {
                console.log("mapAreaVisible changed to: " + theme.mapAreaVisible)
                console.log("Loaded component: " + (theme.mapAreaVisible ? "backgroundRect" : "backgroundImage"))
            }
        }
    }

    Header {
        id: headerLayout
        z: 99
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
        anchors {
            left: parent.left
            top: headerLayout.bottom
            leftMargin: 18
        }
    }

    Button {
        text: "Test Logger"
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 20
        }
        z: 1000
        onClicked: {
            logger.logMessage("Test button clicked in QML")
            console.log("Logged message to file")
        }
    }


    // Main layout for map and speedometer when map is visible
       RowLayout {
           id: mapLayout
           visible: theme.mapAreaVisible
           spacing: 0
           anchors.fill: parent

           Item {
               id: carSpeedLayer
               Layout.preferredWidth: 620
               Layout.fillHeight: true

               // Combined car image and digital speedometer
               Item {
                   id: integratedCarSpeed
                   anchors.fill: parent

                   // Display the car image
                   Image {
                       id: carImage
                       anchors {
                           top: parent.top
                           horizontalCenter: parent.horizontalCenter
                           topMargin: -60
                       }
                       source: theme.isDark ? "qrc:/icons/light/sidebar.png" : "qrc:/icons/dark/sidebar-light.png"
                       width: 900
                       height: 1200
                       fillMode: Image.PreserveAspectFit
                   }

                   // Container for the digital speedometer
                   Rectangle {
                       id: digitalSpeedometerContainer
                       width: 240
                       height: 100
                       radius: 15
                       color: "#2A2A2A"
                       border.color: "#00BFFF"
                       border.width: 3
                       anchors {
                           top: carImage.bottom
                           horizontalCenter: parent.horizontalCenter
                           topMargin: -380
                       }
                       gradient: Gradient {
                           GradientStop { position: 0.0; color: "#2A2A2A" }
                           GradientStop { position: 1.0; color: "#1C1C1C" }
                       }
                       layer.enabled: true
                       layer.effect: DropShadow {
                           transparentBorder: true
                           color: "#40000000"
                           radius: 8
                           samples: 16
                           horizontalOffset: 0
                           verticalOffset: 2
                       }

                       // Text to display the current speed
                       Text {
                           id: digitalSpeedText
                           anchors.centerIn: parent
                           text: integratedCarSpeed.speed + " km/h"
                           font.family: "Inter"
                           font.pixelSize: 42
                           font.bold: Font.Bold
                           color: integratedCarSpeed.speed > 150 ? "#FF4500" : "#00BFFF"
                           horizontalAlignment: Text.AlignHCenter
                           verticalAlignment: Text.AlignVCenter
                       }
                   }

                   // Property to hold the current speed
                   property int speed: 0

                   // Timer to increment speed gradually up to 180 km/h and then fluctuate
                   Timer {
                       id: speedTimer
                       interval: 200 // Update every 200ms for realistic fluctuations
                       running: mapLayout.visible
                       repeat: true
                       onTriggered: {
                           if (integratedCarSpeed.speed < 180) {
                               integratedCarSpeed.speed += 1 // Increment by 1 km/h until 180
                               console.log("Speed updated to:", integratedCarSpeed.speed, "km/h")
                               logger.logMessage("Speed updated to: " + integratedCarSpeed.speed + " km/h")
                           } else {
                               // Generate random speed between 170 and 180
                               var minSpeed = 170
                               var maxSpeed = 180
                               var randomSpeed = Math.floor(Math.random() * (maxSpeed - minSpeed + 1)) + minSpeed
                               integratedCarSpeed.speed = randomSpeed
                               console.log("Speed fluctuated to:", integratedCarSpeed.speed, "km/h")
                               logger.logMessage("Speed fluctuated to: " + integratedCarSpeed.speed + " km/h")
                           }
                       }
                   }
               }
           }

           // Navigation map component
           NavigationMapHelperScreen {
               Layout.fillWidth: true
               Layout.fillHeight: true
               runMenuAnimation: true
           }
       }

    LaunchPadControl {
        id: launcher
        y: (root.height - height) / 2 + footerLayout.height
        x: (root.width - width) / 2
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
        onCaraokeClicked: caraokePopup.open()
        onTheaterClicked: theaterPopup.open()
        onToyboxClicked: toyboxPopup.open()
        onFrontDefrostClicked: frontDefrostPopup.open()
        onRearDefrostClicked: rearDefrostPopup.open()
        onLeftSeatClicked: leftSeatPopup.open()
        onHeatedSteeringClicked: heatedSteeringPopup.open()
        onWipersClicked: wipersPopup.open()
    }

    PhonePopup { id: phonePopup }
    BluetoothPopup { id: bluetoothPopup }
    RadioPopup { id: radioPopup }
    SpotifyPopup { id: spotifyPopup }
    DashcamPopup { id: dashcamPopup }
    TuneinPopup { id: tuneinPopup }
    MusicPopup { id: musicPopup }
    CalendarPopup { id: calendarPopup }
    ZoomPopup { id: zoomPopup }
    MessagesPopup { id: messagesPopup }
    CaraokePopup { id: caraokePopup }
    TheaterPopup { id: theaterPopup }
    ToyboxPopup { id: toyboxPopup }
    FrontDefrostPopup { id: frontDefrostPopup }
    RearDefrostPopup { id: rearDefrostPopup }
    LeftSeatPopup { id: leftSeatPopup }
    HeatedSteeringPopup { id: heatedSteeringPopup }
    WipersPopup { id: wipersPopup }
}
