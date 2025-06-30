// Base popup component for modals in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import Style 1.0

Component {
    id: basePopup
    Popup {
        id: popup
        anchors.centerIn: parent
        width: 400
        height: 500
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        padding: 0

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
            NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200 }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
        }

        background: Rectangle {
            color: theme.isDark ? "#212121" : "#fafafa"
            radius: 20
            border.color: theme.isDark ? "#424242" : "#e0e0e0"
            border.width: 1
        }
    }
}
