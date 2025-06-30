import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import QtQuick.Window 2.15
import Style 1.0

Page {
    id: pageMap
    property bool runMapAnimation: true
    property bool enableGradient: true
    property bool isArabic: true
    padding: 0

    // Default coordinates (will be overridden by file)
    property var referenceCoordinate: QtPositioning.coordinate(30.5871, 31.5020)

    // Animation properties
    property var coordinatesList: []
    property int currentCoordinateIndex: 0
    property bool isMoving: false
    property int animationDuration: 5000 // 5 seconds per movement
    property int pauseDuration: 100 // 0.1 second pause between movements

    // Simulation properties
    property var simulationCoordinates: []
    property int currentSimulationIndex: 0
    property bool simulationRunning: false
    property bool simulationPaused: false
    property bool brakeTriggered: false
    property var frontMarkerCoordinate: referenceCoordinate
    property var followingMarkerCoordinate: referenceCoordinate
    property bool markersVisible: false
    property int brakeCoordinateIndex: 3 // Brake at 4th coordinate (0-based index 3)

    // File dialog to select coordinates file
    FileDialog {
        id: fileDialog
        title: isArabic ? "حدد ملف الإحداثيات" : "Select coordinates file"
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        onAccepted: {
            loadCoordinatesFromFile(fileDialog.file)
        }
    }

    // Animation for marker movement
    PropertyAnimation {
        id: markerAnimation
        target: referenceMarker
        property: "coordinate"
        duration: animationDuration
        easing.type: Easing.InOutQuad

        onFinished: {
            if (coordinatesList.length > 1 && currentCoordinateIndex < coordinatesList.length - 1) {
                pauseTimer.start()
            } else {
                isMoving = false
                showError(isArabic ? "انتهت الرحلة" : "Journey completed")
            }
        }
    }

    // Timer for pause between movements
    Timer {
        id: pauseTimer
        interval: pauseDuration
        onTriggered: {
            if (coordinatesList.length > 1) {
                currentCoordinateIndex++
                if (currentCoordinateIndex >= coordinatesList.length) {
                    currentCoordinateIndex = 0
                }
                moveToNextCoordinate()
            }
        }
    }

    // Simulation animation for front marker
    PropertyAnimation {
        id: frontMarkerAnimation
        target: frontMarker
        property: "coordinate"
        duration: 5000 // Fixed 5 seconds between coordinates
        easing.type: Easing.InOutQuad
    }

    // Simulation animation for following marker
    PropertyAnimation {
        id: followingMarkerAnimation
        target: followingMarker
        property: "coordinate"
        duration: 5000 // Fixed 5 seconds between coordinates
        easing.type: Easing.InOutQuad
    }

    // Simulation timer
    Timer {
        id: simulationTimer
        interval: 5000 // 5 seconds per movement
        running: false
        repeat: true
        onTriggered: {
            if (!simulationPaused) {
                moveSimulationMarkers()
            }
        }
    }

    // Brake warning
    MapQuickItem {
        id: brakeWarning
        coordinate: frontMarker.coordinate
        anchorPoint.x: brakeWarningItem.width / 2
        anchorPoint.y: -10 // Position above the marker
        visible: false
        z: 100
        sourceItem: Rectangle {
            id: brakeWarningItem
            width: 300
            height: 60
            color: "#FF4444"
            border.color: "#CC0000"
            border.width: 3
            radius: 15

            Text {
                anchors.centerIn: parent
                text: "Watch Out! Sudden Brake!"
                font.pixelSize: 16
                font.bold: true
                color: "white"
            }

            SequentialAnimation on opacity {
                running: brakeWarning.visible
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }
        }
    }

    Timer {
        id: brakeWarningTimer
        interval: 5000 // Show warning for 5 seconds
        onTriggered: {
            brakeWarning.visible = false
            simulationPaused = false // Resume movement after warning disappears
        }
    }

    function startSimulation() {
        if (simulationCoordinates.length < 4) {
            showError(isArabic ? "يجب أن يحتوي الملف على 4 إحداثيات على الأقل" : "File must contain at least 4 coordinates")
            return
        }

        simulationRunning = true
        simulationPaused = false
        brakeTriggered = false
        currentSimulationIndex = 0
        markersVisible = true
        frontMarkerCoordinate = simulationCoordinates[0]
        followingMarkerCoordinate = simulationCoordinates[0]
        map.center = frontMarkerCoordinate
        simulationTimer.start()
    }

    function pauseSimulation() {
        simulationPaused = !simulationPaused
        if (simulationPaused) {
            frontMarkerAnimation.pause()
            followingMarkerAnimation.pause()
        } else {
            frontMarkerAnimation.resume()
            followingMarkerAnimation.resume()
        }
    }

    function stopSimulation() {
        simulationRunning = false
        simulationPaused = false
        simulationTimer.stop()
        markersVisible = false
        brakeWarning.visible = false
        frontMarkerAnimation.stop()
        followingMarkerAnimation.stop()
    }

    function moveSimulationMarkers() {
        if (currentSimulationIndex < simulationCoordinates.length - 1) {
            currentSimulationIndex++

            // Move front marker unless we're at brake point
            if (currentSimulationIndex !== brakeCoordinateIndex || brakeTriggered) {
                frontMarkerAnimation.from = frontMarkerCoordinate
                frontMarkerCoordinate = simulationCoordinates[currentSimulationIndex]
                frontMarkerAnimation.to = frontMarkerCoordinate
                frontMarkerAnimation.start()
            }

            // Move following marker (one coordinate behind)
            if (currentSimulationIndex > 0) {
                followingMarkerAnimation.from = followingMarkerCoordinate
                followingMarkerCoordinate = simulationCoordinates[currentSimulationIndex - 1]
                followingMarkerAnimation.to = followingMarkerCoordinate
                followingMarkerAnimation.start()
            }

            // Trigger sudden brake at 4th coordinate (index 3)
            if (currentSimulationIndex === brakeCoordinateIndex && !brakeTriggered) {
                brakeTriggered = true
                brakeWarning.coordinate = frontMarkerCoordinate
                brakeWarning.visible = true
                simulationPaused = true // Pause movement during warning
                brakeWarningTimer.start()
            }

            map.center = frontMarkerCoordinate
        } else {
            stopSimulation()
        }
    }

    function moveToNextCoordinate() {
        if (currentCoordinateIndex < coordinatesList.length) {
            var distance = referenceMarker.coordinate.distanceTo(coordinatesList[currentCoordinateIndex])
            animationDuration = Math.max(3000, Math.min(10000, distance * 20))

            markerAnimation.from = referenceMarker.coordinate
            markerAnimation.to = coordinatesList[currentCoordinateIndex]
            markerAnimation.duration = animationDuration
            markerAnimation.start()

            map.center = coordinatesList[currentCoordinateIndex]

            var coordText = isArabic ?
                        `الانتقال إلى النقطة ${currentCoordinateIndex + 1}/${coordinatesList.length}` :
                        `Moving to point ${currentCoordinateIndex + 1}/${coordinatesList.length}`
            showError(coordText)
        }
    }

    function startMarkerMovement() {
        if (coordinatesList.length === 0) {
            showError(isArabic ? "لا توجد إحداثيات للحركة" : "No coordinates for movement")
            return
        }

        if (coordinatesList.length === 1) {
            referenceMarker.coordinate = coordinatesList[0]
            map.center = coordinatesList[0]
            showError(isArabic ? "تم وضع العلامة على الإحداثية" : "Marker positioned at coordinate")
            return
        }

        isMoving = true
        currentCoordinateIndex = 0
        referenceMarker.coordinate = coordinatesList[0]
        map.center = coordinatesList[0]

        if (coordinatesList.length > 1) {
            currentCoordinateIndex = 1
            moveToNextCoordinate()
        }
    }

    function stopMarkerMovement() {
        isMoving = false
        markerAnimation.stop()
        pauseTimer.stop()
        showError(isArabic ? "تم إيقاف الحركة" : "Movement stopped")
    }

    function loadCoordinatesFromFile(fileUrl) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", fileUrl)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    parseCoordinates(xhr.responseText)
                } else {
                    console.log("Error loading file: " + xhr.status)
                    showError(isArabic ? "خطأ في تحميل الملف" : "Error loading file")
                }
            }
        }
        xhr.send()
    }

    function parseCoordinates(text) {
        var lines = text.split('\n')
        var validCoordinates = []

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.length > 0 && !line.startsWith('#') && !line.startsWith('//')) {
                var coords = line.replace(/\s+/g, ' ').split(/[,\s]+/)
                if (coords.length >= 2) {
                    var lat = parseFloat(coords[0])
                    var lon = parseFloat(coords[1])

                    if (!isNaN(lat) && !isNaN(lon) && lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
                        validCoordinates.push(QtPositioning.coordinate(lat, lon))
                    }
                }
            }
        }

        if (validCoordinates.length > 0) {
            coordinatesList = validCoordinates
            simulationCoordinates = validCoordinates
            referenceCoordinate = coordinatesList[0]
            showError(isArabic ? `تم تحميل ${coordinatesList.length} إحداثية بنجاح` :
                             `Successfully loaded ${coordinatesList.length} coordinates`)
        } else {
            showError(isArabic ? "لم يتم العثور على إحداثيات صالحة في الملف" : "No valid coordinates found in file")
        }
    }

    // Predefined locations with Arabic and English names
    property var locations: [
        {"nameAr": "القاهره", "nameEn": "Cairo", "coordinate": QtPositioning.coordinate(30.0444, 31.2357)},
        {"nameAr": "الزقازيق", "nameEn": "Zagazig", "coordinate": QtPositioning.coordinate(30.5877, 31.5020)},
        {"nameAr": "جامعة الزقازيق", "nameEn": "Zagazig University", "coordinate": QtPositioning.coordinate(30.5871, 31.5020)},
        {"nameAr": "غزه", "nameEn": "Gaza", "coordinate": QtPositioning.coordinate(31.5017, 34.4668)},
        {"nameAr": "الشرقيه", "nameEn": "Sharqia", "coordinate": QtPositioning.coordinate(30.7327, 31.7195)},
        {"nameAr": "القليوبيه", "nameEn": "Qalyubia", "coordinate": QtPositioning.coordinate(30.4667, 31.2167)},
        {"nameAr": "أمريكا", "nameEn": "Washington D.C.", "coordinate": QtPositioning.coordinate(38.8951, -77.0364)},
        {"nameAr": "العتبه", "nameEn": "Ataba", "coordinate": QtPositioning.coordinate(30.0526, 31.2466)},
        {"nameAr": "العبور", "nameEn": "Obour", "coordinate": QtPositioning.coordinate(30.2289, 31.4630)},
        {"nameAr": "الإسكندريه", "nameEn": "Alexandria", "coordinate": QtPositioning.coordinate(31.2001, 29.9187)},
        {"nameAr": "الجيزه", "nameEn": "Giza", "coordinate": QtPositioning.coordinate(30.0131, 31.2089)},
        {"nameAr": "بورسعيد", "nameEn": "Port Said", "coordinate": QtPositioning.coordinate(31.2653, 32.3019)},
        {"nameAr": "السويس", "nameEn": "Suez", "coordinate": QtPositioning.coordinate(29.9668, 32.5371)},
        {"nameAr": "المنصوره", "nameEn": "Mansoura", "coordinate": QtPositioning.coordinate(31.0409, 31.3785)},
        {"nameAr": "طنطا", "nameEn": "Tanta", "coordinate": QtPositioning.coordinate(30.7833, 31.0000)},
        {"nameAr": "أسيوط", "nameEn": "Asyut", "coordinate": QtPositioning.coordinate(27.1801, 31.1859)},
        {"nameAr": "الفيوم", "nameEn": "Fayoum", "coordinate": QtPositioning.coordinate(29.3084, 30.8428)},
        {"nameAr": "دمياط", "nameEn": "Damietta", "coordinate": QtPositioning.coordinate(31.4165, 31.8133)},
        {"nameAr": "كفر الشيخ", "nameEn": "Kafr El Sheikh", "coordinate": QtPositioning.coordinate(31.1107, 30.9399)},
        {"nameAr": "بنها", "nameEn": "Banha", "coordinate": QtPositioning.coordinate(30.4667, 31.1833)},
        {"nameAr": "دمنهور", "nameEn": "Damanhur", "coordinate": QtPositioning.coordinate(31.0341, 30.4682)},
        {"nameAr": "المنيا", "nameEn": "Minya", "coordinate": QtPositioning.coordinate(28.1122, 30.7499)},
        {"nameAr": "سوهاج", "nameEn": "Sohag", "coordinate": QtPositioning.coordinate(26.5569, 31.6948)},
        {"nameAr": "قنا", "nameEn": "Qena", "coordinate": QtPositioning.coordinate(26.1642, 32.7267)},
        {"nameAr": "أسوان", "nameEn": "Aswan", "coordinate": QtPositioning.coordinate(24.0889, 32.8998)},
        {"nameAr": "الأقصر", "nameEn": "Luxor", "coordinate": QtPositioning.coordinate(25.6872, 32.6396)},
        {"nameAr": "شبين الكوم", "nameEn": "Shebin El Kom", "coordinate": QtPositioning.coordinate(30.5591, 31.0111)},
        {"nameAr": "المحلة الكبرى", "nameEn": "El Mahalla El Kubra", "coordinate": QtPositioning.coordinate(30.9750, 31.1669)},
        {"nameAr": "مرسى مطروح", "nameEn": "Marsa Matruh", "coordinate": QtPositioning.coordinate(31.3500, 27.2117)},
        {"nameAr": "الغردقه", "nameEn": "Hurghada", "coordinate": QtPositioning.coordinate(27.2579, 33.8116)},
        {"nameAr": "بلبيس", "nameEn": "Belbeis", "coordinate": QtPositioning.coordinate(30.4202, 31.5622)},
        {"nameAr": "لندن", "nameEn": "London", "coordinate": QtPositioning.coordinate(51.5074, -0.1278)},
        {"nameAr": "باريس", "nameEn": "Paris", "coordinate": QtPositioning.coordinate(48.8566, 2.3522)},
        {"nameAr": "مدريد", "nameEn": "Madrid", "coordinate": QtPositioning.coordinate(40.4168, -3.7038)},
        {"nameAr": "روما", "nameEn": "Rome", "coordinate": QtPositioning.coordinate(41.9028, 12.4964)},
        {"nameAr": "برلين", "nameEn": "Berlin", "coordinate": QtPositioning.coordinate(52.5200, 13.4050)},
        {"nameAr": "موسكو", "nameEn": "Moscow", "coordinate": QtPositioning.coordinate(55.7558, 37.6173)},
        {"nameAr": "اسطنبول", "nameEn": "Istanbul", "coordinate": QtPositioning.coordinate(41.0082, 28.9784)},
        {"nameAr": "طوكيو", "nameEn": "Tokyo", "coordinate": QtPositioning.coordinate(35.6762, 139.6503)},
        {"nameAr": "سيول", "nameEn": "Seoul", "coordinate": QtPositioning.coordinate(37.5665, 126.9780)},
        {"nameAr": "سيدني", "nameEn": "Sydney", "coordinate": QtPositioning.coordinate(-33.8688, 151.2093)},
        {"nameAr": "تورونتو", "nameEn": "Toronto", "coordinate": QtPositioning.coordinate(43.6510, -79.3470)},
        {"nameAr": "ريو دي جانيرو", "nameEn": "Rio de Janeiro", "coordinate": QtPositioning.coordinate(-22.9068, -43.1729)},
        {"nameAr": "الشروق", "nameEn": "El Shorouk", "coordinate": QtPositioning.coordinate(30.1500, 31.6000)},
        {"nameAr": "بدر", "nameEn": "Badr", "coordinate": QtPositioning.coordinate(30.1167, 31.7333)}
    ]

    // Search function
    function searchLocation(query) {
        var cleanedQuery = cleanQuery(query)
        if (cleanedQuery === "") {
            showError(isArabic ? "الرجاء إدخال موقع صالح" : "Please enter a valid location")
            return
        }

        // Check predefined locations (case-insensitive for both Arabic and English)
        for (var i = 0; i < locations.length; i++) {
            if (locations[i].nameAr.toLowerCase().includes(cleanedQuery.toLowerCase()) ||
                    locations[i].nameEn.toLowerCase().includes(cleanedQuery.toLowerCase())) {
                destinationMarker.coordinate = locations[i].coordinate
                destinationMarker.visible = true
                destinationMarker.sourceItem.locationName = isArabic ? locations[i].nameAr : locations[i].nameEn
                destinationMarker.sourceItem.locationCoordinates = locations[i].coordinate
                map.center = locations[i].coordinate
                calculateDistance()
                errorMessage.visible = false
                searchBusyIndicator.running = false
                return
            }
        }

        // Fallback to geocode for dynamic search (supports Arabic/English)
        geocodeModel.query = cleanedQuery
        geocodeModel.update()
        searchBusyIndicator.running = true
    }

    function showError(message) {
        errorMessage.text = message
        errorMessage.visible = true
        errorHideTimer.start()
    }

    function cleanQuery(query) {
        return query.trim().replace(/[^a-zA-Z0-9\s\u0600-\u06FF]/g, "").replace(/\s+/g, " ")
    }

    function calculateDistance() {
        var startCoord = referenceCoordinate
        var endCoord = destinationMarker.coordinate
        var distance = startCoord.distanceTo(endCoord) / 1000 // Distance in kilometers
        distanceBalloon.text = isArabic ? `المسافة: ${distance.toFixed(2)} كم` : `Distance: ${distance.toFixed(2)} km`
        distanceBalloon.visible = true
    }

    // Map
    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin {
            name: "osm"
            PluginParameter {
                name: "osm.mapping.providersrepository.disabled"
                value: "true"
            }
            PluginParameter {
                name: "osm.mapping.providersrepository.address"
                value: "http://maps-redirect.qt.io/osm/5.15/"
            }
        }
        center: referenceCoordinate
        zoomLevel: 15

        // Fixed reference marker (now reads from file)
        MapQuickItem {
            id: referenceMarker
            anchorPoint.x: 16
            anchorPoint.y: 16
            visible: true
            coordinate: referenceCoordinate
            sourceItem: Rectangle {
                width: 32
                height: 32
                radius: 16
                color: "#00FF00" // Green
                border.color: "#006400" // Dark green border
                border.width: 2
                DropShadow {
                    anchors.fill: parent
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 8
                    samples: 16
                    color: "#80000000"
                    source: parent
                }
            }
        }

        // Front marker (Blue)
        MapQuickItem {
            id: frontMarker
            anchorPoint.x: 16
            anchorPoint.y: 16
            coordinate: frontMarkerCoordinate
            visible: markersVisible
            sourceItem: Rectangle {
                width: 32
                height: 32
                radius: 16
                color: "#0066FF" // Blue
                border.color: "#003399"
                border.width: 2
                DropShadow {
                    anchors.fill: parent
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 8
                    samples: 16
                    color: "#80000000"
                    source: parent
                }
            }
        }

        // Following marker (Red)
        MapQuickItem {
            id: followingMarker
            anchorPoint.x: 16
            anchorPoint.y: 16
            coordinate: followingMarkerCoordinate
            visible: markersVisible
            sourceItem: Rectangle {
                width: 32
                height: 32
                radius: 16
                color: "#FF3333" // Red
                border.color: "#CC0000"
                border.width: 2
                DropShadow {
                    anchors.fill: parent
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 8
                    samples: 16
                    color: "#80000000"
                    source: parent
                }
            }
        }

        // Dynamic destination marker (Elegant Red Circle)
        MapQuickItem {
            id: destinationMarker
            anchorPoint.x: 16
            anchorPoint.y: 16
            visible: false
            coordinate: QtPositioning.coordinate(0, 0)
            sourceItem: Item {
                property string locationName: ""
                property var locationCoordinates: QtPositioning.coordinate()

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: "#FF0000" // Red
                    border.color: "#8B0000" // Dark red border
                    border.width: 2
                    DropShadow {
                        anchors.fill: parent
                        horizontalOffset: 2
                        verticalOffset: 2
                        radius: 8
                        samples: 16
                        color: "#80000000"
                        source: parent
                    }
                }
                Text {
                    id: coordinatesText
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: isArabic ? "إحداثيات: " + locationCoordinates.latitude.toFixed(4) + ", " + locationCoordinates.longitude.toFixed(4)
                                   : "Coordinates: " + locationCoordinates.latitude.toFixed(4) + ", " + locationCoordinates.longitude.toFixed(4)
                    font.pixelSize: 12
                    color: Style.isDark ? "white" : "black"
                    visible: destinationMarker.visible
                }
            }
        }

        // Distance Balloon (Sky Blue)
        MapQuickItem {
            id: distanceBalloonItem
            anchorPoint.x: -50
            anchorPoint.y: -50
            coordinate: QtPositioning.coordinate((referenceMarker.coordinate.latitude + destinationMarker.coordinate.latitude) / 2,
                                                 (referenceMarker.coordinate.longitude + destinationMarker.coordinate.longitude) / 2)
            visible: destinationMarker.visible
            sourceItem: Rectangle {
                id: distanceBalloon
                width: distanceText.width + 20
                height: distanceText.height + 20
                color: "#87CEEB" // Sky blue color
                radius: 10
                border.color: "#4682B4" // Steel blue border
                visible: false

                Text {
                    id: distanceText
                    anchors.centerIn: parent
                    text: ""
                    font.pixelSize: 14
                    color: "black"
                }
            }
        }

        PinchArea {
            id: pinchArea
            anchors.fill: parent
            enabled: true
            onPinchUpdated: {
                if (pinch.scale > 0) {
                    var newZoomLevel = map.zoomLevel + Math.log2(pinch.scale)
                    map.zoomLevel = Math.max(2, Math.min(20, newZoomLevel))
                }
                var pinchCenter = Qt.point(pinch.center.x, pinch.center.y)
                var newCenter = map.toCoordinate(pinchCenter)
                map.center = newCenter
            }

            MouseArea {
                id: mapMouseArea
                anchors.fill: parent
                property real lastX: -1
                property real lastY: -1
                property bool isDragging: false

                onPressed: {
                    lastX = mouse.x
                    lastY = mouse.y
                    isDragging = true
                    virtualKeyboard.visible = false
                }

                onPositionChanged: {
                    if (isDragging) {
                        var dx = (mouse.x - lastX) * 0.5
                        var dy = (mouse.y - lastY) * 0.5
                        var newCenter = map.toCoordinate(Qt.point(map.width/2 - dx, map.height/2 - dy))
                        map.center = newCenter
                        lastX = mouse.x
                        lastY = mouse.y
                    }
                }

                onReleased: {
                    isDragging = false
                }

                onWheel: {
                    if (wheel.angleDelta.y > 0) {
                        if (map.zoomLevel < 20) map.zoomLevel += 0.5
                    } else {
                        if (map.zoomLevel > 2) map.zoomLevel -= 0.5
                    }
                    wheel.accepted = true
                }
            }
        }
    }

    // Search bar
    Rectangle {
        id: searchBar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: Math.min(parent.width * 0.9, 500)
        height: 50
        radius: 25
        color: Style.searchFieldBackground
        border.color: Style.isDark ? Style.black40 : Style.black20
        z: 2

        TextField {
            id: searchField
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 50
            placeholderText: isArabic ? "ابحث عن موقع..." : "Search location..."
            font.pixelSize: 16
            color: Style.searchFieldText
            background: Rectangle { color: "transparent" }
            onAccepted: {
                searchLocation(text)
                virtualKeyboard.visible = false
            }
            onActiveFocusChanged: {
                if (activeFocus) {
                    virtualKeyboard.visible = true
                }
            }
        }

        RoundButton {
            id: searchButton
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            onClicked: {
                searchLocation(searchField.text)
                virtualKeyboard.visible = false
            }
            background: Rectangle {
                color: Style.isDark ? Style.black40 : Style.white80
                radius: 20
            }
            contentItem: Image {
                source: "qrc:/images/search_icon.png"
                anchors.centerIn: parent
                width: 20
                height: 20
            }
        }

        BusyIndicator {
            id: searchBusyIndicator
            anchors.right: searchButton.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30
            running: false
        }
    }

    // Virtual keyboard
    Rectangle {
        id: virtualKeyboard
        width: Math.min(parent.width * 0.9, 600)
        height: 300
        color: Style.isDark ? Style.black10 : Style.black80
        radius: 10
        visible: false
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: searchBar.bottom
            topMargin: 20
        }
        z: 2

        Column {
            anchors.centerIn: parent
            spacing: 10

            Row {
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: isArabic ? ["١","٢","٣","٤","٥","٦","٧","٨","٩","٠"] : ["1","2","3","4","5","6","7","8","9","0"]
                    Button {
                        width: 40
                        height: 40
                        text: modelData
                        onClicked: searchField.text += text
                    }
                }
            }

            Row {
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: isArabic ? ["ض","ص","ث","ق","ف","غ","ع","ه","خ","ح"] : ["q","w","e","r","t","y","u","i","o","p"]
                    Button {
                        width: 40
                        height: 40
                        text: modelData
                        onClicked: searchField.text += text
                    }
                }
            }

            Row {
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: isArabic ? ["ش","س","ي","ب","ل","ا","ت","ن","م","ك"] : ["a","s","d","f","g","h","j","k","l"]
                    Button {
                        width: 40
                        height: 40
                        text: modelData
                        onClicked: searchField.text += text
                    }
                }
            }

            Row {
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    width: 60
                    height: 40
                    text: "A/E"
                    onClicked: {
                        isArabic = !isArabic
                        searchField.placeholderText = isArabic ? "ابحث عن موقع..." : "Search location..."
                    }
                }
                Repeater {
                    model: isArabic ? ["ظ","ط","ذ","د","ز","ج","و","ر"] : ["z","x","c","v","b","n","m",","]
                    Button {
                        width: 40
                        height: 40
                        text: modelData
                        onClicked: searchField.text += text
                    }
                }
            }

            Row {
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    width: 100
                    height: 40
                    text: isArabic ? "مسافة" : "Space"
                    onClicked: searchField.text += " "
                }
                Button {
                    width: 60
                    height: 40
                    text: isArabic ? "حذف" : "Delete"
                    onClicked: searchField.text = searchField.text.slice(0, -1)
                }
                Button {
                    width: 60
                    height: 40
                    text: isArabic ? "بحث" : "Search"
                    onClicked: {
                        searchLocation(searchField.text)
                        virtualKeyboard.visible = false
                    }
                }
                Button {
                    width: 60
                    height: 40
                    text: isArabic ? "إغلاق" : "Close"
                    onClicked: virtualKeyboard.visible = false
                }
            }
        }
    }

    // Control buttons
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 15
        z: 2

        Button {
            width: 50
            height: 50
            text: "+"
            font.pixelSize: 24
            onClicked: if (map.zoomLevel < 20) map.zoomLevel += 0.5
        }

        Button {
            width: 50
            height: 50
            text: "-"
            font.pixelSize: 24
            onClicked: if (map.zoomLevel > 2) map.zoomLevel -= 0.5
        }

        Button {
            width: 50
            height: 50
            text: "⌨"
            font.pixelSize: 20
            onClicked: virtualKeyboard.visible = !virtualKeyboard.visible
        }

        // Button to load coordinates from file
        Button {
            width: 50
            height: 50
            text: "📁"
            font.pixelSize: 20
            onClicked: fileDialog.open()
        }

        // Button to start/stop marker movement
        Button {
            width: 50
            height: 50
            text: isMoving ? "⏹" : "▶"
            font.pixelSize: 20
            onClicked: {
                if (isMoving) {
                    stopMarkerMovement()
                } else {
                    if (coordinatesList.length > 0) {
                        startMarkerMovement()
                    } else {
                        showError(isArabic ? "لا توجد إحداثيات للحركة" : "No coordinates for movement")
                    }
                }
            }
        }

        // Button to control simulation
        Button {
            width: 50
            height: 50
            text: simulationRunning ? (simulationPaused ? "▶" : "⏸") : "🚦"
            font.pixelSize: 20

            property int clickCount: 0
            property Timer clickTimer

            onClicked: {
                if (!clickTimer) {
                    clickTimer = Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 300; repeat: false }', this)
                    clickTimer.triggered.connect(function() {
                        if (clickCount === 1) {
                            // Single click - pause/resume
                            if (simulationRunning) {
                                pauseSimulation()
                            } else {
                                if (coordinatesList.length >= 4) {
                                    startSimulation()
                                } else {
                                    showError(isArabic ? "قم بتحميل ملف يحتوي على 4 إحداثيات على الأقل" : "Please load a file with at least 4 coordinates")
                                }
                            }
                        } else if (clickCount >= 3) {
                            // Triple click - stop
                            stopSimulation()
                        }
                        clickCount = 0
                    })
                }

                clickCount++
                clickTimer.restart()
            }
        }
    }

    // Geocode model
    GeocodeModel {
        id: geocodeModel
        plugin: map.plugin
        autoUpdate: false
        onStatusChanged: {
            searchBusyIndicator.running = false
            if (status === GeocodeModel.Ready && count > 0) {
                var location = get(0)
                destinationMarker.coordinate = location.coordinate
                destinationMarker.visible = true
                destinationMarker.sourceItem.locationName = isArabic ? (location.address.text || "موقع غير معروف") : (location.address.text || "Unknown location")
                destinationMarker.sourceItem.locationCoordinates = location.coordinate
                map.center = location.coordinate
                calculateDistance()
                errorMessage.visible = false
            } else if (status === GeocodeModel.Error || count === 0) {
                showError(isArabic ? "الموقع غير موجود" : "Location not found")
            }
        }
    }

    // Error message
    Rectangle {
        id: errorMessage
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        width: 300
        height: 50
        radius: 5
        color: "#FFCDD2"
        visible: false
        z: 2

        Text {
            anchors.centerIn: parent
            text: errorMessage.text
            color: "#D32F2F"
            font.pixelSize: 14
        }
    }

    Timer {
        id: errorHideTimer
        interval: 3000
        onTriggered: errorMessage.visible = false
    }

    Component.onCompleted: {
    }
}
