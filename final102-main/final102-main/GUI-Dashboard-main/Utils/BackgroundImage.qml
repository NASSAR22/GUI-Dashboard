// Background image component for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import Style 1.0

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
