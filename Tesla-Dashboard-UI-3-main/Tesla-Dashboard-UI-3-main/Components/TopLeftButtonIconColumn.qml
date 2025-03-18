import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.15 // Required for ColorOverlay and Glow effects

ColumnLayout {
    spacing: 3 // Spacing between icons in the vertical layout

    // Properties to track the state of each icon (ON/OFF)
    property bool isHeadlightOn: false          // Tracks if the headlight is ON or OFF
    property bool isAutoHeadlightOn: false     // Tracks if the auto headlight mode is ON or OFF
    property bool isLowBeamOn: false           // Tracks if the low beam is ON or OFF
    property bool isSeatbeltWarningOn: true    // Tracks if the seatbelt warning is ON or OFF (default is ON)

    // Headlight Icon
    Item {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // Center the icon in the layout
        width: 48  // Fixed width for the icon
        height: 48 // Fixed height for the icon

        Icon {
            id: headlightIcon
            anchors.fill: parent // Fill the parent Item
            icon.source: "qrc:/light-icons/Headlight2.svg" // Source path for the headlight icon
        }

        // Glow effect to simulate the headlight turning on
        Glow {
            anchors.fill: headlightIcon
            source: headlightIcon
            radius: 8
            samples: 16
            color: isHeadlightOn ? "#FFFFFF" : "transparent" // White glow when ON, transparent when OFF
            visible: isHeadlightOn // Show glow only when headlight is ON
        }

        ColorOverlay {
            anchors.fill: headlightIcon
            source: headlightIcon
            color: isHeadlightOn ? "#00FF00" : "#808080" // Green when ON, gray when OFF
        }

        MouseArea {
            anchors.fill: parent // Make the entire icon area clickable
            onClicked: {
                isHeadlightOn = !isHeadlightOn // Toggle the headlight state
                console.log("Headlight is now:", isHeadlightOn ? "ON" : "OFF") // Log the state change
            }
        }
    }

    // Auto Headlight Icon
    Item {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // Center the icon in the layout
        width: 48  // Fixed width for the icon
        height: 48 // Fixed height for the icon

        Icon {
            id: autoHeadlightIcon
            anchors.fill: parent // Fill the parent Item
            icon.source: "qrc:/light-icons/Property 1=Default.svg" // Source path for the auto headlight icon
        }

        // Glow effect to simulate auto headlight activation
        Glow {
            anchors.fill: autoHeadlightIcon
            source: autoHeadlightIcon
            radius: 8
            samples: 16
            color: isAutoHeadlightOn ? "#00FF00" : "transparent" // Green glow when ON, transparent when OFF
            visible: isAutoHeadlightOn // Show glow only when auto headlight is ON
        }

        ColorOverlay {
            anchors.fill: autoHeadlightIcon
            source: autoHeadlightIcon
            color: isAutoHeadlightOn ? "#00FF00" : "#808080" // Green when ON, gray when OFF
        }

        MouseArea {
            anchors.fill: parent // Make the entire icon area clickable
            onClicked: {
                isAutoHeadlightOn = !isAutoHeadlightOn // Toggle the auto headlight state
                console.log("Auto Headlight is now:", isAutoHeadlightOn ? "ON" : "OFF") // Log the state change
            }
        }
    }

    // Low Beam Icon
    Item {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // Center the icon in the layout
        width: 48  // Fixed width for the icon
        height: 48 // Fixed height for the icon

        Icon {
            id: lowBeamIcon
            anchors.fill: parent // Fill the parent Item
            icon.source: "qrc:/light-icons/Headlights.svg" // Source path for the low beam icon
        }

        // Glow effect to simulate low beam turning on
        Glow {
            anchors.fill: lowBeamIcon
            source: lowBeamIcon
            radius: 6 // Slightly smaller radius for low beam effect
            samples: 12
            color: isLowBeamOn ? "#FFFFFF" : "transparent" // White glow when ON, transparent when OFF
            visible: isLowBeamOn // Show glow only when low beam is ON
        }

        ColorOverlay {
            anchors.fill: lowBeamIcon
            source: lowBeamIcon
            color: isLowBeamOn ? "#00FF00" : "#808080" // Green when ON, gray when OFF
        }

        MouseArea {
            anchors.fill: parent // Make the entire icon area clickable
            onClicked: {
                isLowBeamOn = !isLowBeamOn // Toggle the low beam state
                console.log("Low Beam is now:", isLowBeamOn ? "ON" : "OFF") // Log the state change
            }
        }
    }

    // Seatbelt Warning Icon
    Item {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter // Center the icon in the layout
        width: 48  // Fixed width for the icon
        height: 48 // Fixed height for the icon

        Icon {
            id: seatbeltIcon
            anchors.fill: parent // Fill the parent Item
            icon.source: "qrc:/light-icons/Seatbelt.svg" // Source path for the seatbelt warning icon
        }

        // Sequential animation to simulate flashing warning
        SequentialAnimation {
            id: seatbeltFlash
            running: isSeatbeltWarningOn // Run animation when seatbelt warning is ON
            loops: Animation.Infinite // Infinite loop for flashing effect
            ColorAnimation {
                target: seatbeltColorOverlay
                property: "color"
                from: "#FF0000"
                to: "#808080"
                duration: 500
            }
            ColorAnimation {
                target: seatbeltColorOverlay
                property: "color"
                from: "#808080"
                to: "#FF0000"
                duration: 500
            }
        }

        ColorOverlay {
            id: seatbeltColorOverlay
            anchors.fill: seatbeltIcon
            source: seatbeltIcon
            color: isSeatbeltWarningOn ? "#FF0000" : "#808080" // Red when ON, gray when OFF (overridden by animation)
        }

        MouseArea {
            anchors.fill: parent // Make the entire icon area clickable
            onClicked: {
                isSeatbeltWarningOn = !isSeatbeltWarningOn // Toggle the seatbelt warning state
                console.log("Seatbelt Warning is now:", isSeatbeltWarningOn ? "ON" : "OFF") // Log the state change
                if (!isSeatbeltWarningOn) seatbeltFlash.stop() // Stop animation when turned OFF
            }
        }
    }
}
