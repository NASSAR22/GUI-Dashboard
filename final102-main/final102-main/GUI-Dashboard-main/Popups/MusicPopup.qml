// Music player popup for streaming online channels in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtMultimedia 5.15

// Music player popup for online streaming channels
Popup {
    id: musicPopup
    anchors.centerIn: parent
    width: 500
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Property to track the currently selected stream index
    property int currentStreamIndex: -1

    // Music player for streaming online channels
    MediaPlayer {
        id: musicPlayer
        source: ""
        volume: musicVolumeSlider.value / 100 // Direct volume mapping
        onError: {
            errorText.text = "Error: " + errorString + "\nCode: " + error
            errorText.visible = true
            console.log("Music Player error:", error, errorString)
            musicPlayPauseButton.text = "▶"
        }
        onPlaying: {
            errorText.visible = false
            musicPlayPauseButton.text = "⏸"
        }
        onStopped: {
            musicPlayPauseButton.text = "▶"
        }
    }

    // List model for online music streaming channels
    ListModel {
        id: musicStreamingModel
        ListElement { name: "Groove Salad (Chillhandle)"; streamUrl: "http://ice1.somafm.com/groovesalad-128-mp3" }
        ListElement { name: "PopTron (Pop)"; streamUrl: "http://ice1.somafm.com/poptron-128-mp3" }
        ListElement { name: "Lush (Electronic)"; streamUrl: "http://ice1.somafm.com/lush-128-mp3" }
        ListElement { name: "Hip Hop (Urban)"; streamUrl: "http://ice1.somafm.com/beatblender-128-mp3" }
    }

    // Popup background
    Rectangle {
        anchors.fill: parent
        color: Style.isDark ? "#212121" : "#fafafa"
        radius: 20
        border.color: Style.isDark ? "#424242" : "#e0e0e0"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            // Popup title
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Music Streaming"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            // Current streaming channel display
            Text {
                id: currentStreamText
                Layout.alignment: Qt.AlignHCenter
                text: musicPlayer.source.toString().split('/').pop() || "No stream selected"
                font.family: "Inter"
                font.pixelSize: 18
                color: Style.isDark ? "#ffffff" : "#424242"
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            // Error message for streaming issues
            Text {
                id: errorText
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

            // List of streaming channels
            ListView {
                id: streamList
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                clip: true
                model: musicStreamingModel
                delegate: Button {
                    width: parent.width
                    height: 60
                    text: name
                    font.family: "Inter"
                    font.pixelSize: 18
                    onClicked: {
                        musicPlayer.stop()
                        musicPlayer.source = streamUrl
                        musicPlayer.play()
                        errorText.visible = false
                        musicPlayPauseButton.text = "⏸"
                        currentStreamIndex = index
                        currentStreamText.text = name
                        console.log("Playing stream:", name)
                        logger.logMessage("Music stream: " + name + " started")
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

            // Loading indicator for streaming
            BusyIndicator {
                id: musicLoadingIndicator
                Layout.alignment: Qt.AlignHCenter
                running: musicPlayer.status === MediaPlayer.Loading
                visible: running
            }

            // Playback controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                // Play/Pause button
                Button {
                    id: musicPlayPauseButton
                    text: "▶"
                    width: 80
                    height: 80
                    onClicked: {
                        if (musicPlayer.playbackState === MediaPlayer.PlayingState) {
                            musicPlayer.pause()
                            text = "▶"
                            console.log("Music stream paused")
                            logger.logMessage("Music stream paused")
                        } else {
                            if (musicPlayer.source.toString() === "" && currentStreamIndex === -1) {
                                if (musicStreamingModel.count > 0) {
                                    currentStreamIndex = 0 // Select first stream if none selected
                                    var firstStream = musicStreamingModel.get(currentStreamIndex)
                                    musicPlayer.source = firstStream.streamUrl
                                    musicPlayer.play()
                                    text = "⏸"
                                    currentStreamText.text = firstStream.name
                                    errorText.visible = false
                                    console.log("Playing stream:", firstStream.name)
                                    logger.logMessage("Music stream: " + firstStream.name + " started")
                                } else {
                                    errorText.text = "No streams available"
                                    errorText.visible = true
                                    console.log("No streams available for play button")
                                }
                            } else {
                                musicPlayer.play()
                                text = "⏸"
                                console.log("Music stream playing")
                                logger.logMessage("Music stream playing")
                            }
                        }
                    }
                    background: Rectangle {
                        color: "#4caf50"
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

                // Stop button
                Button {
                    text: "Stop"
                    width: 80
                    height: 80
                    onClicked: {
                        musicPlayer.stop()
                        musicPlayPauseButton.text = "▶"
                        console.log("Music stream stopped")
                        logger.logMessage("Music stream stopped")
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

            // Volume control with volume level display
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
                    id: musicVolumeSlider
                    width: 150
                    from: 100
                    to: 0
                    value: 50
                    onValueChanged: {
                        musicPlayer.volume = value / 100
                        volumeLevelText.text = Math.round(value) + "%"
                    }
                }

                Text {
                    id: volumeLevelText
                    text: Math.round(musicVolumeSlider.value) + "%"
                    font.family: "Inter"
                    font.pixelSize: 16
                    color: Style.isDark ? "#ffffff" : "#424242"
                }
            }

            // Close button
            Button {
                text: "Close"
                width: 120
                height: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                onClicked: {
                    musicPlayer.stop()
                    musicPlayPauseButton.text = "▶"
                    musicPopup.close()
                    console.log("Music popup closed")
                    logger.logMessage("Music popup closed")
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
