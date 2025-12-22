import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "transparent"
    height: 80

    // Alt kısımdaki yamuk şekilli arka plan görseli
    // (Bunu QML Shapes ile çizmek karmaşık olabilir, görseldeki gibi basit bir
    // dikdörtgen veya görsel kullanmanız daha kolaydır. Şimdilik basit tutuyoruz)
    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        color: "#111111"
        opacity: 0.5
        radius: 10
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 40

        // Vitesler
        Repeater {
            model: ["P", "R", "N", "D"]
            Text {
                text: modelData
                // "D" seçili gibi yapalım
                color: modelData === "D" ? "#FFFFFF" : "#555555"
                font.pixelSize: 32
                font.bold: true
            }
        }
    }
    // İkon satırı (Viteslerin üstüne)
    Row {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        // Örnek ikon yer tutucular (Kendi ikonlarınızı buraya ekleyin)
        Rectangle { width: 24; height: 24; color: "green"; radius: 12 } // Far
        Rectangle { width: 24; height: 24; color: "red"; radius: 12 }   // Arıza
    }
}
