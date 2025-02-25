import QtQuick 2.15
Rectangle {
    id: bottomBar
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    height: parent.height / 12
    color: "black"
    Image {
        id: carSettingIcon
        anchors{
            left: parent.left
            leftMargin: 30
            verticalCenter: parent.verticalCenter
        }
        height: parent.height * .85
        fillMode: Image.PreserveAspectFit
        source: "qrc:/ui/assets/racing-car.png"
    }

    HVACComponent {
        id: driverHVACControl
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: carSettingIcon.right
            leftMargin: 60
        }

        hvacController: driverHVAC
    }


    HVACComponent {
        id: passengerHVACControl
        anchors{
            top: parent.top
            bottom: parent.bottom
            right: volumeControl.left
            rightMargin: 160
        }
        hvacController: passengerHVAC
    }

    VolumeControlComponent{
        id: volumeControl
        anchors{
            right: parent.right
            rightMargin: 30
            top: parent.top
            bottom: parent.bottom
        }
    }
}
