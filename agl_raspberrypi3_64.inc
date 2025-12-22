# Maximum memory allowed to be assigned
GPU_MEM = "128"

# Add CMA to the kernel arguments for SOTA
#OSTREE_KERNEL_ARGS:sota:append = " cma=256M"

# use u-boot always
RPI_USE_U_BOOT = "1"

# Use UART for serial console
ENABLE_UART ?= "1"

# For libomxil
#LICENSE_FLAGS_ACCEPTED += "commercial"

# For linux-firmware-rpidistro
LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"

IMAGE_INSTALL:append = " kernel-modules linux-firmware-rpidistro-bcm43430 linux-firmware-rpidistro-bcm43455 create-combined-dtb "

# Psplash causes crash on first boot on RPi
IMAGE_FEATURES:remove = "splash"

#DISPLAY CONFIGURATION
#WESTON_DISPLAYS:raspberrypi3-64 = " DSI-1"

ENABLE_I2C="1"

KERNEL_MODULE_AUTOLOAD:append = " i2c-dev i2c-bcm2835"
#RPI_EXTRA_CONFIG:append = " \n dtoverlay=vc4-kms-dsi-7inch \n "
RPI_EXTRA_CONFIG:append = "dtoverlay=vc4-kms-dsi-waveshare5 \n"
RPI_EXTRA_CONFIG:append = "dtoverlay=vc4-kms-dsi-7inch-raspberrypi3-64"
