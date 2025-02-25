import QtQuick 2.15

Item {
    property string fontColor: "#f0eded"

    Connections{
        target: AudioController
        function onVolumeLevelChanged() {
            visibleTimer.stop()
            volumeIcon.visible = false
            visibleTimer.start()
        }
    }

    Timer {
        id: visibleTimer
        interval: 1000
        repeat: false
        onTriggered: {
            volumeIcon.visible = true

        }

    }

    Rectangle{
        id: decrementButton
        anchors{
            right: volumeIcon.left
            rightMargin: 15
            top: parent.top
            bottom: parent.bottom
        }
        width: height / 2
        color: "black"
        Text {
            id: decrementText
            color: fontColor
            anchors.centerIn: parent
            text: "<"
            font.pixelSize: 12
        }
        MouseArea{
            anchors.fill: parent
            onClicked: AudioController.incrementVolume( - 1 )
        }
    }
    Image {
        id: volumeIcon
        height: parent.height * .5
        fillMode: Image.PreserveAspectFit
        anchors{
            right: incrementButton.left
            rightMargin: 25
            verticalCenter: parent.verticalCenter
        }
        source:{
            if (AudioController.volumeLevel < 1 )
                return "qrc:/ui/assets/mute.png"
            else if (AudioController.volumeLevel <= 50 )
                return "qrc:/ui/assets/low-volume.png"
            else
                return "qrc:/ui/assets/medium-volume.png"
        }

    }
    Text {
        id: volumeTextLabel
        visible: !volumeIcon.visible
        anchors{
            centerIn: volumeIcon
        }
        color: fontColor
        font.pixelSize: 24
        text: AudioController.volumeLevel
    }

    width: 130 * (parent.width / 1280 )

    Rectangle{
        id: incrementButton
        anchors{
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: height / 2
        color: "black"
        Text {
            id: incrementText
            color: fontColor
            anchors.centerIn: parent
            text: ">"
            font.pixelSize: 12
        }

        MouseArea{
            anchors.fill: parent
            onClicked: AudioController.incrementVolume( 1 )
        }
    }

}
