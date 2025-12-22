SUMMARY = "Custom AGL Ricefish Instrument Cluster"
DESCRIPTION = "A QML based custom instrument cluster dashboard."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "qtbase agl-compositor qtdeclarative qtbase-native qtquickcontrols2 qtwayland qtwayland-native libqtappfw glib-2.0 wayland wayland-native"

SRC_URI = " \
    file://CMakeLists.txt \
    file://main.cpp \
    file://protocol/agl-shell.xml \
    file://protocol/agl-shell-desktop.xml \
    file://qml/ \
    file://assets/ \
    file://qml.qrc \
    file://my-ricefish-cluster.service \
    file://custom-cluster-omur.token \
    file://custom-cluster-omur.conf.demo \
    file://custom-cluster-omur.conf.default \
"

S = "${WORKDIR}"

inherit cmake_qt5 systemd pkgconfig update-alternatives


CLUSTER_DEMO_VSS_HOSTNAME ??= "192.168.10.2"

SYSTEMD_SERVICE:${PN} = "my-ricefish-cluster.service"
#SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    install -D -m0644 ${WORKDIR}/my-ricefish-cluster.service \
        ${D}${systemd_system_unitdir}/my-ricefish-cluster.service

    # VIS authorization token file for KUKSA.val should ideally not
    # be readable by other users, but currently that's not doable
    # until a packaging/sandboxing/MAC scheme is (re)implemented or
    # something like OAuth is plumbed in as an alternative.
    # VIS authorization token file for KUKSA.val should ideally not
    # be readable by other users, but currently that's not doable
    # until a packaging/sandboxing/MAC scheme is (re)implemented or
    # something like OAuth is plumbed in as an alternative.
    install -d ${D}${sysconfdir}/xdg/AGL/my-ricefish-cluster
    install -m 0644 ${WORKDIR}/custom-cluster-omur.conf.default ${D}${sysconfdir}/xdg/AGL/
    install -m 0644 ${WORKDIR}/custom-cluster-omur.conf.demo ${D}${sysconfdir}/xdg/AGL/
    install -m 0644 ${WORKDIR}/custom-cluster-omur.token ${D}${sysconfdir}/xdg/AGL/my-ricefish-cluster/
}
ALTERNATIVE_LINK_NAME[custom-cluster-omur.conf] = "${sysconfdir}/xdg/AGL/custom-cluster-omur.conf"

PACKAGE_BEFORE_PN += "${PN}-conf"
FILES:${PN}-conf += "${sysconfdir}/xdg/AGL/custom-cluster-omur.conf.default"
RDEPENDS:${PN}-conf = "${PN}"
RPROVIDES:${PN}-conf = "custom-cluster-omur.conf"
ALTERNATIVE:${PN}-conf = "custom-cluster-omur.conf"
ALTERNATIVE_TARGET_${PN}-conf = "${sysconfdir}/xdg/AGL/custom-cluster-omur.conf.default"

PACKAGE_BEFORE_PN += "${PN}-conf-demo"
FILES:${PN}-conf-demo += "${sysconfdir}/xdg/AGL/custom-cluster-omur.conf.demo"
RDEPENDS:${PN}-conf-demo = "${PN}"
RPROVIDES:${PN}-conf-demo = "custom-cluster-omur.conf"
ALTERNATIVE:${PN}-conf-demo = "custom-cluster-omur.conf"
ALTERNATIVE_TARGET_${PN}-conf-demo = "${sysconfdir}/xdg/AGL/custom-cluster-omur.conf.demo"

AGL_APP_NAME = "MyRicefishCluster"


FILES:${PN} += " \
    /usr/bin/MyRicefishCluster \
    /usr/share/MyRicefishCluster \
    ${systemd_system_unitdir}/my-ricefish-cluster.service \
"
RDEPENDS:${PN} += " \
    qtwayland \
    qtwayland-qmlplugins \
    qtquickcontrols2 \
    qtquickcontrols \
    qtwayland-plugins \
    qtbase-plugins \
    qtbase-qmlplugins \
    qtgraphicaleffects-qmlplugins \
    qtdeclarative-qmlplugins \
    qtquickcontrols2-qmlplugins \
"

