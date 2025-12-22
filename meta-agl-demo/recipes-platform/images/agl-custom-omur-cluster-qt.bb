DESCRIPTION = "AGL Cluster Custom-Omur Platform image currently contains a simple cluster interface."

LICENSE = "MIT"

require recipes-platform/images/agl-image-compositor.bb
require agl-custom-omur-qt-features.inc

RDEPENDS:${PN} += "my-ricefish-cluster"

IMAGE_FEATURES += "splash package-management ssh-server-openssh"

inherit features_check

REQUIRED_DISTRO_FEATURES = "wayland"

IMAGE_FEATURES += " \
    kuksa-val-databroker-client \
    kuksa-val-databroker \
"

# Set up for testing with the databroker when using agl-devel
AGL_DEVEL_INSTALL = " \
    custom-cluster-demo-omur-config \
    simple-can-simulator \
"

#QT_CLUSTER_DASHBOARD_CONF = "custom-cluster-demo-omur-conf"

# add packages for cluster demo platform (include demo apps) here
IMAGE_INSTALL += " \
    packagegroup-agl-custom-omur-qt-platform \
    kuksa-certificates-agl-ca \
    weston-ini-conf-landscape \
    ${@bb.utils.contains("DISTRO_FEATURES", "agl-devel", "${AGL_DEVEL_INSTALL}" , "", d)} \
    ${@bb.utils.contains("AGL_FEATURES", "AGLCI", "qemu-set-display", "", d)} \
"
