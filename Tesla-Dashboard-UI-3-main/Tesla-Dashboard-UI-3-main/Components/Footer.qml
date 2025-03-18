import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.15

Item {
    height: 120
    width: parent.width
    signal openLauncher()      // Signal to open the launcher
    signal phoneClicked()      // Signal for Phone icon
    signal bluetoothClicked()  // Signal for Bluetooth icon
    signal radioClicked()      // Signal for Radio icon
    signal spotifyClicked()    // Signal for Spotify icon
    signal dashcamClicked()    // Signal for Dashcam icon
    signal tuneinClicked()     // Signal for TuneIn icon
    signal musicClicked()      // Signal for Music icon
    signal calendarClicked()   // Signal for Calendar icon
    signal zoomClicked()       // Signal for Zoom icon
    signal messagesClicked()   // Signal for Messages icon

    // Background gradient for the Footer
    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, 1000)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.black }
            GradientStop { position: 1.0; color: Style.black60 }
        }
    }

    // Left control icon (Model 3) to open the launcher
    Icon {
        id: leftControl
        icon.source: "qrc:/icons/app_icons/model-3.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 36
        onClicked: openLauncher()
    }

    // Left StepperControl area
    Item {
        height: parent.height
        anchors.left: leftControl.right
        anchors.right: middleLayout.left
        anchors.verticalCenter: parent.verticalCenter

        StepperControl {
            anchors.centerIn: parent
            value: 72
        }
    }

    // Middle row layout containing app icons
    RowLayout {
        id: middleLayout
        anchors.centerIn: parent
        spacing: 20

        // Phone icon
        Icon {
            id: phoneIcon
            icon.source: "qrc:/icons/app_icons/phone.svg"
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: phoneClicked()
            }
        }

        // Radio icon
        Icon {
            id: radioIcon
            icon.source: "qrc:/icons/app_icons/radio.svg"
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: radioClicked()
            }
        }

        // Bluetooth icon
        Icon {
            id: bluetoothIcon
            icon.source: "qrc:/icons/app_icons/bluetooth.svg"
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: bluetoothClicked()
            }
        }

        // Spotify icon
        Icon {
            id: spotifyIcon
            icon.source: "qrc:/icons/app_icons/spotify.svg"
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: spotifyClicked()
            }
        }

        // Dashcam icon
        Icon {
            id: dashcamIcon
            icon.source: "qrc:/icons/app_icons/dashcam.svg"
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: dashcamClicked()
            }
        }

        // Music icon
        Icon {
            id: musicIcon
            icon.source: "qrc:/icons/app_icons/volume.svg" // Example icon for Music
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: musicClicked()
            }
        }

        // TuneIn icon
        Icon {
            id: tuneinIcon
            icon.source: "qrc:/icons/app_icons/tunein.svg"
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: tuneinClicked()
            }
        }

        // Calendar icon
        Icon {
            id: calendarIcon
            icon.source: "qrc:/icons/app_icons/calendar.svg" // Placeholder for Calendar
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: calendarClicked()
            }
        }

        // Zoom icon
        Icon {
            id: zoomIcon
            icon.source: "qrc:/icons/app_icons/zoom.svg" // Placeholder for Zoom
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: zoomClicked()
            }
        }

        // Messages icon
        Icon {
            id: messagesIcon
            icon.source: "qrc:/icons/app_icons/messages.svg" // Placeholder for Messages
            width: 48
            height: 48
            MouseArea {
                anchors.fill: parent
                onClicked: messagesClicked()
            }
        }
    }

    // Right StepperControl area
    Item {
        height: parent.height
        anchors.right: rightControl.left
        anchors.left: middleLayout.right
        anchors.verticalCenter: parent.verticalCenter

        StepperControl {
            anchors.centerIn: parent
            value: 72
        }
    }

    // Right control (volume) stepper
    StepperControl {
        id: rightControl
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 36
        value: 72
        icon: "qrc:/icons/app_icons/volume.svg"
    }
}
