# 🚗 AGL Digital Instrument Cluster (Raspberry Pi 3)

A custom digital instrument cluster application developed for **Automotive Grade Linux (AGL)**, running on a **Raspberry Pi 3 (64-bit)**. This project demonstrates the full pipeline of integrating a **Qt/QML** based HMI into a custom Yocto image.

https://github.com/user-attachments/assets/45c08014-11fd-411f-846d-fe322cedfb27

text=AGL+Cluster+Screenshot+Placeholder)

## 📖 Overview

This repository contains the source code and Yocto recipes for a digital dashboard featuring a speedometer, tachometer (RPM), and gear indicators. It is specifically designed to run on the **AGL Ricefish** release.

The project highlights the journey of embedded Linux development:
* Building a custom **Yocto** image from scratch.
* Creating a custom meta-layer (`meta-custom-cluster`).
* Developing a responsive UI with **Qt5/Qt6 & QML**.
* Deploying to embedded hardware (**Raspberry Pi 3** with a **5-inch DSI Display**).

## 🛠 Tech Stack & Hardware

| Category | Details |
|----------|---------|
| **Hardware** | Raspberry Pi 3 Model B+ (64-bit) |
| **Display** | Waveshare 5-inch DSI LCD (800x480) |
| **OS** | Automotive Grade Linux (AGL) - Ricefish / UCB 17.x |
| **Build System** | Yocto Project (BitBake) |
| **UI Framework** | Qt 5.15 / Qt 6 (QML) |
| **Build Tool** | CMake |
| **Dev Env** | WSL2 (Ubuntu 24.04 LTS) |

## 📂 Repository Structure

The repository is structured to fit into the AGL Yocto ecosystem as a custom application:

```text
Raspberrypi-AutomotiveGradeLinuxBasedApps/
└── meta-custom-cluster/
    ├── conf/
    │   └── layer.conf                 # Yocto Layer Configuration (Priority & Compatibility)
    └── recipes-apps/
        └── my-ricefish-cluster/
            ├── my-ricefish-cluster.bb # Main BitBake Recipe
            └── files/                 # Application Source Root
                ├── CMakeLists.txt     # Build configuration
                ├── main.cpp           # C++ Entry Point (Loads QML)
                ├── qml
                     └── main.qml           # Main UI Logic (Inline Gauge Components)
                ├── my-ricefish-cluster.service # AGL Launcher Configuration
                ├── qtquickcontrols2.conf # Qt Style Configuration (Essential for Fonts/Theme)
                ├── custom-cluster-omur.conf.default           # Default conf
                ├── protocol           # Wayland protocols
                └── assets/            # Graphic Assets
                    ├── app-icon.png   # App Launcher Icon
                    ├── fuel-icon.png  # Fuel Warning Icon
                    └── needle.png     # (Optional) Custom Needle Image

```

## ✨ Features

* **Dual Gauge Design:** Speedometer (Left) and Tachometer (Right).
* **Resolution Optimized:** Specifically tuned for **800x480** screens (no scaling artifacts).
* **Simulation Mode:** Currently simulates speed and RPM data via a QML Timer (for testing without vehicle hardware).
* **Dynamic UI:** Uses `QtGraphicalEffects` (Qt5) or `MultiEffect` (Qt6) for glows and shadows.
* **Fast Boot:** Optimized for quick startup within the AGL environment.

## 🚀 How to Build (Yocto Integration)

To integrate this application into your AGL image, follow these steps:

### 1. Setup AGL Environment (Ricefish)

```bash
repo init -b ricefish -u [https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo](https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo)
repo sync

```

### 2. Add Custom Layer

Copy the recipe files from this repository into your custom layer structure (e.g., `meta-custom-cluster/recipes-apps/my-cluster`).

### 3. Configure Build

Initialize the build environment for Raspberry Pi 3:

```bash
source meta-agl/scripts/aglsetup.sh -m raspberrypi3-64 agl-demo agl-netboot

```

### 4. Build the Application

```bash
bitbake agl-custom-omur-cluster-qt

```
meta-agl-demo/recipes-platform/images demo cluster images recipe and packagegroup can be found here
## 🗺 Roadmap

* [x] Basic UI Implementation (QML)
* [x] Yocto Integration & RPi3 Deployment
* [x] 800x480 Resolution Optimization
* [ ] **Next Step:** Replace simulation data with real-time CAN bus signals using **KUKSA.val** and **gRPC**.
* [ ] Add Warning Indicators (Check Engine, Battery, etc.)

## 🤝 Contributing

This is a learning project documenting my journey into Embedded Linux. Suggestions, pull requests, and feedback are always welcome!

## 📜 License

This project is licensed under the MIT License.

---

**Developed by Omur Ceran**

```

```
