// Radio popup for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtMultimedia 5.15

Popup {
    id: radioPopup
    anchors.centerIn: parent
    width: 500
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Radio player
    MediaPlayer {
        id: radioPlayer
        source: ""
        volume: radioVolumeSlider.value / 100
        onError: {
            radioErrorText.text = "Error: " + errorString + "\nCode: " + error
            radioErrorText.visible = true
            console.log("Radio Player error:", error, errorString)
            radioPlayPauseButton.text = "▶"
        }
        onPlaying: {
            radioErrorText.visible = false
            radioPlayPauseButton.text = "⏸"
        }
        onStopped: {
            radioPlayPauseButton.text = "▶"
        }
    }

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
                text: "Internet Radio"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            Text {
                id: currentStationText
                Layout.alignment: Qt.AlignHCenter
                text: radioPlayer.source.toString().split('/').pop() || "No station selected"
                font.family: "Inter"
                font.pixelSize: 18
                color: Style.isDark ? "#ffffff" : "#424242"
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: radioErrorText
                Layout.alignment: Qt.AlignHCenter
                text: ""
                font.family: "Inter"
                font.pixelSize: 16
                color: "#F44336"
                visible: false
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            ListView {
                id: radioListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                clip: true
                model: ListModel {
                    id: radioStationsModel
                    ListElement { name: "NPR"; streamUrl: "https://npr-ice.streamguys1.com/live.mp3" }
                    ListElement { name: "Radio France"; streamUrl: "https://icecast.radiofrance.fr/fip-midfi.mp3" }
                    ListElement { name: "Hip Hop (Urban)"; streamUrl: "http://ice1.somafm.com/beatblender-128-mp3" }
                }
                delegate: Button {
                    width: parent.width
                    height: 60
                    text: name
                    font.family: "Inter"
                    font.pixelSize: 18
                    onClicked: {
                        radioPlayer.stop();
                        radioPlayer.source = streamUrl;
                        radioPlayer.play();
                        currentStationText.text = name;
                        console.log("Playing:", name);
                    }
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
                        elide: Text.ElideRight
                    }
                }
                ScrollBar.vertical: ScrollBar {}
            }

            // Loading indicator for radio
            BusyIndicator {
                id: radioLoadingIndicator
                Layout.alignment: Qt.AlignHCenter
                running: radioPlayer.status === MediaPlayer.Loading
                visible: running
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    id: radioPlayPauseButton
                    text: "▶"
                    width: 80
                    height: 80
                    onClicked: {
                        if (radioPlayer.playbackState === MediaPlayer.PlayingState) {
                            radioPlayer.pause();
                            text = "▶";
                        } else {
                            if (radioPlayer.source.toString() === "") {
                                radioErrorText.text = "Please select a station first";
                                radioErrorText.visible = true;
                            } else {
                                radioPlayer.play();
                                text = "⏸";
                            }
                        }
                    }
                    background: Rectangle {
                        color: "#4CAF50"
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
                    text: "Stop"
                    width: 80
                    height: 80
                    onClicked: {
                        radioPlayer.stop();
                        radioPlayPauseButton.text = "▶";
                    }
                    background: Rectangle {
                        color: "#F44336"
                        radius: 40
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

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Text {
                    text: "Volume:"
                    font.family: "Inter"
                    font.pixelSize: 16
                    color: Style.isDark ? "#ffffff" : "#424242"
                }

                Slider {
                    id: radioVolumeSlider
                    width: 150
                    from: 100
                    to: 0
                    value: 50
                    onValueChanged: {
                        radioPlayer.volume = value / 100;
                    }
                }
            }

            Button {
                text: "Close"
                width: 120
                height: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                onClicked: {
                    radioPlayer.stop();
                    radioPopup.close();
                }
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
