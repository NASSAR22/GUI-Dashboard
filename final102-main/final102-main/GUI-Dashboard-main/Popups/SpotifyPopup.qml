// Spotify popup for the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtMultimedia 5.15

Popup {
    id: spotifyPopup
    anchors.centerIn: parent
    width: 500
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Spotify media player
    MediaPlayer {
        id: spotifyPlayer
        source: ""
        volume: spotifyVolumeSlider.value / 100
        onError: {
            spotifyErrorText.text = "Error: " + errorString + "\nCode: " + error
            spotifyErrorText.visible = true
            console.log("Spotify Player error for source", source, ":", error, errorString)
            spotifyPlayPauseButton.text = "▶"
            logger.logMessage("Spotify Player error: " + errorString + " (Code: " + error + ")")
        }
        onPlaying: {
            spotifyErrorText.visible = false
            spotifyPlayPauseButton.text = "⏸"
            console.log("Spotify Player playing:", source)
            logger.logMessage("Spotify Player playing: " + source)
        }
        onStopped: {
            spotifyPlayPauseButton.text = "▶"
            console.log("Spotify Player stopped")
            logger.logMessage("Spotify Player stopped")
        }
        onStatusChanged: {
            console.log("Spotify Player status:", status)
            logger.logMessage("Spotify Player status: " + status)
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

            // Spotify title
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: "Spotify Playlists"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            // Current playlist display
            Text {
                id: currentPlaylistText
                Layout.alignment: Qt.AlignHCenter
                text: spotifyPlayer.source.toString().split('/').pop() || "No playlist selected"
                font.family: "Inter"
                font.pixelSize: 18
                color: Style.isDark ? "#ffffff" : "#424242"
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            // Error text for Spotify
            Text {
                id: spotifyErrorText
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

            // Spotify playlists list
            ListView {
                id: spotifyListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                clip: true
                model: ListModel {
                    id: spotifyPlaylistsModel
                    // Combined channels from radioListModel and musicStreamingModel
                    ListElement { name: "BBC Radio 1"; streamUrl: "http://stream.live.vc.bbcmedia.co.uk/bbc_radio_one" }
                    ListElement { name: "Jazz FM"; streamUrl: "https://jazz-wr-icecast.musicradio.com/JazzFMMP3" }
                    ListElement { name: "Radio Sawa"; streamUrl: "https://mbnvoice-2.mbn.org/stream/sawa/sawa_64k" }
                    ListElement { name: "NPR"; streamUrl: "https://npr-ice.streamguys1.com/live.mp3" }
                    ListElement { name: "Radio France"; streamUrl: "https://icecast.radiofrance.fr/fip-midfi.mp3" }
                    ListElement { name: "Hip Hop (Urban)"; streamUrl: "http://ice1.somafm.com/beatblender-128-mp3" }
                    ListElement { name: "Groove Salad (Chillhandle)"; streamUrl: "http://ice1.somafm.com/groovesalad-128-mp3" }
                    ListElement { name: "PopTron (Pop)"; streamUrl: "http://ice1.somafm.com/poptron-128-mp3" }
                    ListElement { name: "Lush (Electronic)"; streamUrl: "http://ice1.somafm.com/lush-128-mp3" }
                }
                delegate: Button {
                    width: parent.width
                    height: 60
                    text: name
                    font.family: "Inter"
                    font.pixelSize: 18
                    onClicked: {
                        spotifyPlayer.stop();
                        spotifyPlayer.source = streamUrl;
                        spotifyPlayer.play();
                        currentPlaylistText.text = name;
                        console.log("Attempting to play Spotify playlist:", name, "with URL:", streamUrl);
                        logger.logMessage("Spotify: Attempting to play " + name + " with URL: " + streamUrl);
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

            // Loading indicator for Spotify
            BusyIndicator {
                id: spotifyLoadingIndicator
                Layout.alignment: Qt.AlignHCenter
                running: spotifyPlayer.status === MediaPlayer.Loading
                visible: running
            }

            // Playback controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    id: spotifyPlayPauseButton
                    text: "▶"
                    width: 80
                    height: 80
                    onClicked: {
                        if (spotifyPlayer.playbackState === MediaPlayer.PlayingState) {
                            spotifyPlayer.pause();
                            text = "▶";
                            console.log("Spotify stream paused");
                            logger.logMessage("Spotify stream paused");
                        } else {
                            if (spotifyPlayer.source.toString() === "") {
                                if (spotifyPlaylistsModel.count > 0) {
                                    var firstStream = spotifyPlaylistsModel.get(0);
                                    spotifyPlayer.source = firstStream.streamUrl;
                                    spotifyPlayer.play();
                                    text = "⏸";
                                    currentPlaylistText.text = firstStream.name;
                                    spotifyErrorText.visible = false;
                                    console.log("Playing default Spotify playlist:", firstStream.name);
                                    logger.logMessage("Spotify: Playing default playlist " + firstStream.name);
                                } else {
                                    spotifyErrorText.text = "No streams available";
                                    spotifyErrorText.visible = true;
                                    console.log("No streams available for Spotify play button");
                                    logger.logMessage("Spotify: No streams available");
                                }
                            } else {
                                spotifyPlayer.play();
                                text = "⏸";
                                console.log("Spotify stream playing:", spotifyPlayer.source);
                                logger.logMessage("Spotify stream playing: " + spotifyPlayer.source);
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
                        spotifyPlayer.stop();
                        spotifyPlayPauseButton.text = "▶";
                        console.log("Spotify stream stopped");
                        logger.logMessage("Spotify stream stopped");
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

            // Volume control
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
                    id: spotifyVolumeSlider
                    width: 150
                    from: 0
                    to: 100
                    value: 50
                    onValueChanged: {
                        spotifyPlayer.volume = value / 100;
                        console.log("Spotify volume set to:", value);
                        logger.logMessage("Spotify volume set to: " + value);
                    }
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
                    spotifyPlayer.stop();
                    spotifyPlayPauseButton.text = "▶";
                    spotifyPopup.close();
                    console.log("Spotify popup closed");
                    logger.logMessage("Spotify popup closed");
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
