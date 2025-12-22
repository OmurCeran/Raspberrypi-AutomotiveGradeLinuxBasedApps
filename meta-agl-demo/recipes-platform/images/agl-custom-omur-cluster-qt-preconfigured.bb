require agl-cluster-demo-qt.bb

SUMMARY = "AGL Cluster preconfigured demo Qt image"

# We do not want a local databroker instance
IMAGE_FEATURES:remove = "kuksa-val-databroker"

# We do not want weston-terminal visible
IMAGE_INSTALL:remove = "weston-terminal-conf"

# The cluster screen is rotated in the full demo setup, so the
# default compositor configuration needs to be replaced.
IMAGE_INSTALL:remove = "weston-ini-conf-landscape"

QT_CLUSTER_DASHBOARD_CONF = "custom-cluster-omur-conf"

IMAGE_INSTALL += " \
    my-ricefish-cluster \
    weston-ini-conf-landscape-inverted \
"
