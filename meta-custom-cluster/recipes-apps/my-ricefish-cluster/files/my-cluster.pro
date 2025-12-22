TEMPLATE = app
TARGET = MyRicefishCluster
QT += qml quick

CONFIG += c++17

# Kaynaklar
SOURCES += main.cpp
RESOURCES += qml.qrc

# Yükleme Hedefleri (AGL dosya sisteminde nereye gideceği)
target.path = /usr/bin

#File locations
qml.files = qml assets
qml.path = /usr/share/MyRicefishCluster

#systemd services
#service.files = my-ricefish-cluster.service
#service.path = /lib/systemd/system

#qml.path = /usr/share/MyRicefishCluster/qml
assets.path = /usr/share/MyRicefishCluster/assets

INSTALLS += target qml
