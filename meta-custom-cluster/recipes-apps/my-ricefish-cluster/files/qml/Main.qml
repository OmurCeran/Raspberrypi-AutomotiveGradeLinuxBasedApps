import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Window {
    id: root
    visible: true
    width: 800  // Waveshare 5 inch
    height: 480
    color: "#000000"
    title: "AGL Cluster 5inch Qt5"

    visibility: Window.FullScreen
    
    // 2. Remove frames from screen
    flags: Qt.FramelessWindowHint

    // --- Simulation ---
    property int currentSpeed: 0
    property int currentRPM: 0
    property string currentGear: "D"
    property bool accelerating: true

    Timer {
        interval: 50; running: true; repeat: true
        onTriggered: {
            if (root.accelerating) {
                root.currentSpeed += 1
                if (root.currentSpeed >= 220) root.accelerating = false
            } else {
                root.currentSpeed -= 1
                if (root.currentSpeed <= 0) root.accelerating = true
            }
            root.currentRPM = (root.currentSpeed / 220) * 8000
        }
    }

    // --- Head BAR ---
    Item {
        width: 300; height: 60
        anchors.top: parent.top; anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            color: "#222222"; radius: 25; opacity: 0.8
        }
        Text { text: "Tue 22 Dec"; color: "white"; font.pixelSize: 14; font.bold: true; anchors.centerIn: parent; anchors.verticalCenterOffset: -12 }
        Text { text: "13:45"; color: "#aaa"; font.pixelSize: 12; anchors.centerIn: parent; anchors.verticalCenterOffset: 5 }
        Text { text: "Omur's Cluster"; color: "red"; font.pixelSize: 12; anchors.centerIn: parent; anchors.verticalCenterOffset: 20 }
    }

    // --- SOL GÖSTERGE (HIZ) ---
    GaugeComponent {
        id: speedGauge
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        
        gaugeSize: 280
        maxValue: 240
        currentValue: root.currentSpeed
        labelStep: 20

        centerIconText: "⛽"
        mainColor: "#0088ff"
    }

    // --- SAĞ GÖSTERGE (RPM) ---
    GaugeComponent {
        id: rpmGauge
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        
        gaugeSize: 280
        maxValue: 8
        currentValue: root.currentRPM / 1000
        labelStep: 1

        centerLabelText: "x1000/min"
        mainColor: "#ff0000"
        isRPM: true
    }

    // --- ORTA BİLGİ EKRANI ---
    Item {
        id: centerConsole
        width: 180; height: 300
        anchors.centerIn: parent

        // 1. Üst İkonlar
        Row {
            anchors.top: parent.top; anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            Column {
                Text { text: "🌡️"; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "90°C"; color: "white"; font.pixelSize: 12 }
            }
            Text { text: "🔧"; font.pixelSize: 24; color: "orange" }
        }

        // 2. DİJİTAL HIZ KUTUSU
        Rectangle {
            width: 140; height: 110
            color: "#111111"; radius: 15
            anchors.centerIn: parent
            border.color: "#333"; border.width: 2

            Column {
                anchors.centerIn: parent
                Text {
                    id: speedText
                    text: Math.floor(root.currentSpeed)
                    color: "white"
                    font.pixelSize: 60
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Glow {
                        anchors.fill: parent; source: parent; radius: 4; samples: 10; color: "#0088ff"; visible: false
                    }
                }
                Text {
                    text: "km/h"
                    color: "#aaa"
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: -5
                }
            }
        }

        // 3. Vites
        Column {
            anchors.right: parent.right; anchors.rightMargin: -10
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 30
            spacing: 4
            
            Repeater {
                model: ["P", "R", "N", "D"]
                Rectangle {
                    width: 25; height: 25
                    color: modelData === root.currentGear ? "#0088ff" : "transparent"
                    radius: 4
                    border.color: modelData === root.currentGear ? "transparent" : "#333"
                    
                    Text { 
                        text: modelData; color: "white"; anchors.centerIn: parent
                        font.bold: true; font.pixelSize: 14
                    }
                }
            }
        }
        
        // 4. READY Yazısı
        Rectangle {
            color: "#00ff00"; width: 50; height: 20; radius: 4
            anchors.bottom: parent.bottom; anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            Text { text: "READY"; color: "black"; font.bold: true; font.pixelSize: 10; anchors.centerIn: parent }
        }
    }

    // =================================================================
    // QT 5 GAUGE COMPONENT (Boyutlar Revize Edildi)
    // =================================================================
    component GaugeComponent : Item {
        property int gaugeSize: 280
        property double maxValue: 240
        property double currentValue: 0
        property int labelStep: 20
        
        property string centerIconText: ""
        property string centerLabelText: ""
        property string mainColor: "#0088ff"
        property bool isRPM: false

        width: gaugeSize; height: gaugeSize

        // 1. Dış Çerçeve
        Item {
            anchors.fill: parent
            Rectangle {
                id: bgRect
                anchors.fill: parent; radius: width / 2; color: "#080808"
                border.width: 3; border.color: "#333"; visible: true
            }
            Glow {
                anchors.fill: bgRect; source: bgRect; radius: 8; samples: 17; color: mainColor; opacity: 0.5; transparentBorder: true
            }
        }

        // 2. İç Halka
        Rectangle {
            anchors.fill: parent; anchors.margins: 8; radius: width / 2
            color: "transparent"; border.width: isRPM ? 25 : 12; border.color: mainColor; opacity: 0.2
        }

        // 3. Çizgiler
        Repeater {
            model: (maxValue / labelStep) + 1
            Item {
                property double val: index * labelStep
                property double angle: -135 + (val / maxValue) * 270
                width: parent.width; height: parent.height
                anchors.centerIn: parent; rotation: angle
                Rectangle {
                    width: 10; height: 2; color: "white"
                    anchors.right: parent.right; anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // 4. RAKAMLAR
        Repeater {
            model: (maxValue / labelStep) + 1
            Item {
                anchors.fill: parent
                Text {
                    property double val: index * labelStep
                    property double angleDeg: -135 + (val / maxValue) * 270
                    property double angleRad: angleDeg * (Math.PI / 180)
                    property double radius: (gaugeSize / 2) - 30 
                    x: (parent.width / 2) + radius * Math.cos(angleRad) - (width / 2)
                    y: (parent.height / 2) + radius * Math.sin(angleRad) - (height / 2)
                    text: val
                    color: "white"; font.pixelSize: 12; font.bold: true
                }
            }
        }

        // 5. MERKEZ İKON/YAZI
        Item {
            anchors.fill: parent
            Text {
                text: centerIconText
                color: "white"
                font.pixelSize: 28
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 35
                visible: text !== ""
            }
            Text {
                text: centerLabelText
                color: "#aaa"
                font.pixelSize: 12
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 25
                visible: text !== ""
            }
        }

        // 6. İbre
        Item {
            id: needle
            width: gaugeSize; height: gaugeSize
            anchors.centerIn: parent
            rotation: -135 + ((currentValue / maxValue) * 270)
            Rectangle {
                width: (gaugeSize / 2) - 15; height: 4; color: "red"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.horizontalCenter; anchors.leftMargin: -5
                radius: 2
            }
            Glow {
                anchors.fill: needle; source: needle; radius: 4; samples: 10; color: "red"; opacity: 0.8; transparentBorder: true
            }
            Rectangle {
                width: 16; height: 16; radius: 8; color: "#222"; border.color: "#555"; border.width: 1; anchors.centerIn: parent
            }
            Behavior on rotation { SmoothedAnimation { velocity: 400; duration: 200 } }
        }
    }
}