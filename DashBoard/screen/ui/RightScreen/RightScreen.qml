import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15

Rectangle{
    id: rightScreen

    anchors {
        top: parent.top
        bottom: bottomBar.top
        right: parent.right
    }
    width: parent.width * 2/3
    Plugin {
        id: mapPlugin
        name: "osm"
        //name: "mapboxgl"
        PluginParameter { name: "mapboxgl.access_token"; value: "***" }
    }

    Map {
        anchors.fill: parent
        plugin: mapPlugin
        //center: QtPositioning.coordinate(30.416665, 31.5666644) // Belbeis
        center: QtPositioning.coordinate(30.2993, 31.614) // 10th of ramadan
        zoomLevel: 15
    }

    Image {
        id: lockIcon
        anchors {
            left: parent.left
            top: parent.top
            margins: 20
        }
        width: parent.width / 40
        fillMode: Image.PreserveAspectFit
        source: ( systemHandler.carLocked ? "qrc:/ui/assets/padlock (1).png" : "qrc:/ui/assets/unlocked.png" )
        MouseArea {
            anchors.fill: parent
            onClicked: systemHandler.setcarLocked( !systemHandler.carLocked )
        }
    }

    Text {
        id: dateTimeDisplay
        anchors{
            left: lockIcon.right
            leftMargin: 40
            bottom: lockIcon.bottom
        }

        font.pixelSize: 12
        font.bold: true
        color: "black"

        text: systemHandler.currentTime
    }

    Text {
        id: outdoorTemperatureDisplay
        anchors{
            left: dateTimeDisplay.right
            leftMargin: 40
            bottom: lockIcon.bottom
        }

        font.pixelSize: 12
        font.bold: true
        color: "black"

        text: systemHandler.outdoorTemp + "°c"
    }

    Text {
        id: userNameDisplay
        anchors{
            left: outdoorTemperatureDisplay.right
            leftMargin: 40
            bottom: lockIcon.bottom
        }

        font.pixelSize: 12
        font.bold: true
        color: "black"

        text: systemHandler.userName
    }

    NavigationSearchBox {
        id: navSearchBox

        width: parent.width * 1/3
        height: parent.height * 1/12

        anchors {
            left: lockIcon.left
            top: lockIcon.bottom
            topMargin: 15
        }
    }
}
