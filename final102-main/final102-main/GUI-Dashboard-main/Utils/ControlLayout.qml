// Reusable control layout component for trunk/frunk controls
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

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
