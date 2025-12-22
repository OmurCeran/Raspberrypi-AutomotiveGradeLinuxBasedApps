import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: root
    visible: true
    width: 1920
    height: 720
    color: "#000000"
    title: "AGL Ricefish Cluster"
    flags: Qt.FramelessWindowHint // Tam ekran ve çerçevesiz olması için

    // --- C++ ENTEGRASYONU ---
    // C++ tarafında: context->setContextProperty("runAnimation", runAnimation);
    // Bu özellik main.cpp'den gelir.
    property bool animationEnabled: typeof runAnimation !== "undefined" ? runAnimation : true

    // Araç Verileri
    Item {
        id: carData
        property real speed: 0
        property real rpm: 0
        property string gear: "P"
        property bool leftSignal: false
        property bool rightSignal: false
        
        // --- 1. GERÇEK VERİ BAĞLANTISI (VehicleSignals) ---
        // C++ tarafında: context->setContextProperty("VehicleSignals", ...);
        Connections {
            target: typeof VehicleSignals !== "undefined" ? VehicleSignals : null
            ignoreUnknownSignals: true

            // AGL VehicleSignals kütüphanesinin standart sinyalleri
            function onSpeedChanged(speed) {
                // Gerçek veri geldiğinde simülasyonu durdurabiliriz
                simTimer.running = false 
                carData.speed = speed
                // Vites tahmini
                if (speed === 0) carData.gear = "P"
                else if (speed > 0) carData.gear = "D"
            }
            
            function onEngineSpeedChanged(rpm) {
                carData.rpm = rpm
            }
        }

        // --- 2. SİMÜLASYON (Yedek Sistem) ---
        // Eğer gerçek sinyal yoksa bu Timer çalışır
        property bool accelerating: true
        Timer {
            id: simTimer
            interval: 50
            running: true // Varsayılan olarak açık (Veri gelince kapanır)
            repeat: true
            onTriggered: {
                if (parent.accelerating) {
                    parent.speed += 0.8
                    if (parent.speed >= 220) parent.accelerating = false
                } else {
                    parent.speed -= 0.6
                    if (parent.speed <= 0) parent.accelerating = true
                }
                parent.rpm = (parent.speed * 35) % 8000
                if (parent.rpm < 800) parent.rpm = 800
                
                // Vites Simülasyonu
                if (parent.speed == 0) parent.gear = "P"
                else if (parent.speed < 20) parent.gear = "1"
                else if (parent.speed < 50) parent.gear = "2"
                else parent.gear = "D"
            }
        }

        // Sinyal Timer (Her durumda çalışsın)
        Timer {
            interval: 600; running: true; repeat: true
            onTriggered: { 
                if (root.visible) parent.leftSignal = !parent.leftSignal 
            }
        }
    }

    // --- GÖRSEL BİLEŞENLER (Daha önceki sade tasarım) ---

    // Sol Gösterge (HIZ)
    Item {
        anchors.left: parent.left; anchors.leftMargin: 150
        anchors.verticalCenter: parent.verticalCenter
        width: 400; height: 400

        // Dış Halka
        Rectangle {
            anchors.fill: parent; radius: width/2
            color: "transparent"; border.color: "#333"; border.width: 5
        }
        
        // İbre (Needle)
        Rectangle {
            id: speedNeedle
            width: 6; height: 180; color: "#00b2ff"; radius: 3
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -90 // Merkezi yukarı kaydır
            transformOrigin: Item.Bottom
            rotation: -140 + ((carData.speed / 240) * 280)
            
            Behavior on rotation { NumberAnimation { duration: 300 } }
        }

        // Yazı
        Column {
            anchors.centerIn: parent
            Text { text: Math.floor(carData.speed); color: "white"; font.pixelSize: 60; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "km/h"; color: "#aaa"; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
        }
    }

    // Orta Bilgi
    Rectangle {
        anchors.centerIn: parent
        width: 150; height: 150; radius: 20
        color: "#222"; border.color: "#555"
        
        Text {
            anchors.centerIn: parent
            text: carData.gear
            color: "white"; font.pixelSize: 80; font.bold: true
        }
    }

    // Sağ Gösterge (DEVİR)
    Item {
        anchors.right: parent.right; anchors.rightMargin: 150
        anchors.verticalCenter: parent.verticalCenter
        width: 400; height: 400

        Rectangle {
            anchors.fill: parent; radius: width/2
            color: "transparent"; border.color: "#333"; border.width: 5
        }

        Rectangle {
            id: rpmNeedle
            width: 6; height: 180; color: "#e34c22"; radius: 3
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -90
            transformOrigin: Item.Bottom
            rotation: -140 + ((carData.rpm / 8000) * 280)

            Behavior on rotation { NumberAnimation { duration: 200 } }
        }

        Column {
            anchors.centerIn: parent
            Text { text: Math.floor(carData.rpm); color: "white"; font.pixelSize: 40; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: "RPM"; color: "#aaa"; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
        }
    }
}