import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: gauge
    property string titleText: ""
    property real value: 0
    property real maxValue: 100
    property color accentColor: "blue"

    // Basit bir daire çizimi
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.color: "#333"
        border.width: 4

        // İlerleme Çubuğu (Canvas veya Shape ile yapılabilir, basitlik için Rectangle)
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height * (gauge.value / gauge.maxValue)
            color: gauge.accentColor
            opacity: 0.3
            radius: width/2
            clip: true
        }

        // Değer Yazısı
        Column {
            anchors.centerIn: parent
            Text {
                text: Math.floor(gauge.value)
                color: "white"
                font.pixelSize: parent.width * 0.3
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: gauge.titleText
                color: "#AAA"
                font.pixelSize: parent.width * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
