cmake_minimum_required(VERSION 3.10)
project(MyRicefishCluster LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Gui Qml Quick QuickControls2 REQUIRED)


find_package(PkgConfig REQUIRED)
find_program(WAYLAND_SCANNER_EXECUTABLE NAMES wayland-scanner REQUIRED)

#  Real AGL protocol (version 11)
set(AGL_SHELL_XML "${CMAKE_SOURCE_DIR}/protocol/agl-shell.xml")

#  Wayland protocols (xdg-shell)
pkg_check_modules(WAYLAND_PROTOCOLS REQUIRED wayland-protocols>=1.18)
pkg_get_variable(WAYLAND_PROTOCOLS_BASE wayland-protocols pkgdatadir)
pkg_check_modules(GLIB REQUIRED glib-2.0)
#  Wayland client
pkg_check_modules(WAYLAND_CLIENT REQUIRED wayland-client)

#  AGL Shell – client header
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-client-protocol.h
    COMMAND ${WAYLAND_SCANNER_EXECUTABLE} client-header
            ${AGL_SHELL_XML}
            ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-client-protocol.h
    DEPENDS ${AGL_SHELL_XML}
)

#  AGL Shell – code
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-protocol.c
    COMMAND ${WAYLAND_SCANNER_EXECUTABLE} code
            ${AGL_SHELL_XML}
            ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-protocol.c
    DEPENDS ${AGL_SHELL_XML}
)

#  xdg-shell – client header
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/xdg-shell-client-protocol.h
    COMMAND ${WAYLAND_SCANNER_EXECUTABLE} client-header
            ${WAYLAND_PROTOCOLS_BASE}/stable/xdg-shell/xdg-shell.xml
            ${CMAKE_CURRENT_BINARY_DIR}/xdg-shell-client-protocol.h
    DEPENDS ${WAYLAND_PROTOCOLS_BASE}/stable/xdg-shell/xdg-shell.xml
)

#  xdg-shell – code
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/xdg-shell-protocol.c
    COMMAND ${WAYLAND_SCANNER_EXECUTABLE} code
            ${WAYLAND_PROTOCOLS_BASE}/stable/xdg-shell/xdg-shell.xml
            ${CMAKE_CURRENT_BINARY_DIR}/xdg-shell-protocol.c
    DEPENDS ${WAYLAND_PROTOCOLS_BASE}/stable/xdg-shell/xdg-shell.xml
)

#  QML resources
qt5_add_resources(RESOURCES qml.qrc)

#  Include directories
include_directories(
    ${Qt5Gui_PRIVATE_INCLUDE_DIRS}
    ${GLIB_INCLUDE_DIRS}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${WAYLAND_CLIENT_INCLUDE_DIRS}
)
set_source_files_properties(
    ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-protocol.c
    PROPERTIES LANGUAGE C
)

#  Executable
add_executable(${PROJECT_NAME}
    ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-protocol.c
    ${CMAKE_CURRENT_BINARY_DIR}/agl-shell-client-protocol.h
    ${CMAKE_CURRENT_BINARY_DIR}/xdg-shell-protocol.c
    ${CMAKE_CURRENT_BINARY_DIR}/xdg-shell-client-protocol.h
    main.cpp
    ${RESOURCES}
)

#  Link libraries
target_link_libraries(${PROJECT_NAME}
    Qt5::QuickControls2
    Qt5::Core
    Qt5::Gui
    Qt5::Quick
    Qt5::Qml
    ${QTAPPFW_VEHICLE_SIGNALS_LIBRARIES}
    ${GLIB_LIBRARIES}
    ${WAYLAND_CLIENT_LIBRARIES}
)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
