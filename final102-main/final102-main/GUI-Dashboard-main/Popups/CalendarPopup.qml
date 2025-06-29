// Calendar popup for managing events in the Tesla interface
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

// Calendar popup for date selection, mimicking mobile/laptop calendar with dynamic day highlighting
Popup {
    id: calendarPopup
    anchors.centerIn: parent
    width: 500
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property int selectedDay: -1
    property var currentDate: new Date(2025, 5, 28) // Set to June 28, 2025 (month is 0-based in JS)
    property int displayMonth: currentDate.getMonth() // Initialize to current month (June = 5)
    property int displayYear: currentDate.getFullYear() // Initialize to current year (2025)

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
                text: "Calendar"
                font.family: "Inter"
                font.pixelSize: 24
                font.bold: Font.Medium
                color: Style.isDark ? "#ffffff" : "#212121"
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                ComboBox {
                    id: monthSelector
                    width: 150
                    model: ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"]
                    currentIndex: calendarPopup.displayMonth
                    font.family: "Inter"
                    font.pixelSize: 18
                    displayText: currentIndex >= 0 ? model[currentIndex] : "June"
                    onCurrentIndexChanged: {
                        calendarPopup.displayMonth = currentIndex
                        updateDays()
                    }
                }

                ComboBox {
                    id: yearSelector
                    width: 100
                    model: ListModel {
                        id: yearModel
                        Component.onCompleted: {
                            for (var i = 1990; i <= 2040; i++) {
                                yearModel.append({ "text": i })
                            }
                            currentIndex = yearModel.findIndex(function(item) { return item.text == calendarPopup.displayYear }) || 0
                        }
                        function findIndex(predicate) {
                            for (var i = 0; i < count; i++) {
                                if (predicate(get(i))) return i
                            }
                            return -1
                        }
                    }
                    currentIndex: yearModel.findIndex(function(item) { return item.text == calendarPopup.displayYear }) || 0
                    font.family: "Inter"
                    font.pixelSize: 18
                    displayText: currentIndex >= 0 ? yearModel.get(currentIndex).text : "2025"
                    onCurrentIndexChanged: {
                        calendarPopup.displayYear = parseInt(yearModel.get(currentIndex).text)
                        updateDays()
                    }
                }
            }

            GridLayout {
                id: daysGrid
                columns: 7
                rowSpacing: 10
                columnSpacing: 10
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 20

                Repeater {
                    model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    Text {
                        Layout.fillWidth: true
                        text: modelData
                        font.family: "Inter"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        color: Style.isDark ? "#ffffff" : "#212121"
                    }
                }

                Repeater {
                    id: daysRepeater
                    model: 42 // Maximum grid slots to accommodate any month
                    Item {
                        width: 50
                        height: 50
                        visible: {
                            var daysInMonth = (calendarPopup.displayMonth === 5) ? 30 : new Date(calendarPopup.displayYear, calendarPopup.displayMonth + 1, 0).getDate()
                            var firstDay = new Date(calendarPopup.displayYear, calendarPopup.displayMonth, 1).getDay()
                            var adjustedFirstDay = (firstDay === 0) ? 6 : firstDay - 1
                            var dayNumber = index - adjustedFirstDay + 1
                            return dayNumber > 0 && dayNumber <= daysInMonth
                        }

                        Button {
                            id: dayButton
                            anchors.fill: parent
                            text: {
                                var firstDay = new Date(calendarPopup.displayYear, calendarPopup.displayMonth, 1).getDay()
                                var adjustedFirstDay = (firstDay === 0) ? 6 : firstDay - 1
                                return index - adjustedFirstDay + 1
                            }
                            font.family: "Inter"
                            font.pixelSize: 18
                            onClicked: {
                                calendarPopup.selectedDay = parseInt(text)
                                console.log("Selected day:", calendarPopup.selectedDay, "Month:", calendarPopup.displayMonth + 1, "Year:", calendarPopup.displayYear)
                                logger.logMessage("Calendar: Selected " + calendarPopup.selectedDay + "/" + (calendarPopup.displayMonth + 1) + "/" + calendarPopup.displayYear)
                            }

                            background: Item {
                                anchors.fill: parent

                                Rectangle {
                                    id: dayBackground
                                    anchors.fill: parent
                                    color: {
                                        var dayDate = new Date(calendarPopup.displayYear, calendarPopup.displayMonth, parseInt(dayButton.text))
                                        var today = new Date(calendarPopup.currentDate)
                                        dayDate.setHours(0, 0, 0, 0)
                                        today.setHours(0, 0, 0, 0)

                                        if (dayDate.getTime() === today.getTime()) {
                                            return "#2196F3" // Blue for current day
                                        } else if (calendarPopup.selectedDay === parseInt(dayButton.text)) {
                                            return "#4CAF50" // Green for selected day
                                        } else {
                                            return Style.isDark ? "#424242" : "#ffffff"
                                        }
                                    }
                                    radius: 25
                                    border.color: Style.isDark ? "#616161" : "#e0e0e0"
                                    border.width: 1
                                }

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 40
                                    height: 40
                                    radius: 20
                                    color: "transparent"
                                    border.color: {
                                        var dayDate = new Date(calendarPopup.displayYear, calendarPopup.displayMonth, parseInt(dayButton.text))
                                        var today = new Date(calendarPopup.currentDate)
                                        dayDate.setHours(0, 0, 0, 0)
                                        today.setHours(0, 0, 0, 0)

                                        if (dayDate.getTime() === today.getTime() || calendarPopup.selectedDay === parseInt(dayButton.text)) {
                                            return "#ffffff"
                                        } else {
                                            return "transparent"
                                        }
                                    }
                                    border.width: 2
                                    visible: border.color !== "transparent"
                                }
                            }

                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: {
                                    var dayDate = new Date(calendarPopup.displayYear, calendarPopup.displayMonth, parseInt(dayButton.text))
                                    var today = new Date(calendarPopup.currentDate)
                                    dayDate.setHours(0, 0, 0, 0)
                                    today.setHours(0, 0, 0, 0)

                                    if (dayDate.getTime() === today.getTime() || calendarPopup.selectedDay === parseInt(dayButton.text)) {
                                        return "#ffffff" // White text for current/selected day
                                    } else {
                                        return Style.isDark ? "#ffffff" : "#424242"
                                    }
                                }
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }

            Button {
                text: "Close"
                width: 120
                height: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                onClicked: calendarPopup.close()
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

            function updateDays() {
                var daysInMonth = (calendarPopup.displayMonth === 5) ? 30 : new Date(calendarPopup.displayYear, calendarPopup.displayMonth + 1, 0).getDate()
                console.log("Days in month:", daysInMonth) // Debug log to verify days
                var firstDay = new Date(calendarPopup.displayYear, calendarPopup.displayMonth, 1).getDay()
                var adjustedFirstDay = (firstDay === 0) ? 6 : firstDay - 1

                daysRepeater.model = 42 // Fixed grid for up to 6 weeks
                for (var i = 0; i < daysRepeater.count; i++) {
                    var item = daysRepeater.itemAt(i)
                    if (item) {
                        var dayNumber = i - adjustedFirstDay + 1
                        item.visible = (dayNumber > 0 && dayNumber <= daysInMonth)
                    }
                }
            }

            function isLeapYear(year) {
                return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0)
            }

            Component.onCompleted: {
                updateDays()
                monthSelector.currentIndex = calendarPopup.displayMonth
                yearSelector.currentIndex = yearModel.findIndex(function(item) { return item.text == calendarPopup.displayYear }) || 0
            }

            Timer {
                interval: 86400000 // 24 hours
                running: true
                repeat: true
                onTriggered: {
                    calendarPopup.currentDate.setDate(calendarPopup.currentDate.getDate() + 1)
                    if (calendarPopup.displayMonth === calendarPopup.currentDate.getMonth() &&
                        calendarPopup.displayYear === calendarPopup.currentDate.getFullYear()) {
                        updateDays()
                    }
                }
            }
        }
    }
}
