#include <QGuiApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <qpa/qplatformnativeinterface.h>
#include <QScreen>
#include <QTimer>

#include <wayland-client.h>
extern "C" {
#include "agl-shell-client-protocol.h"
}

extern const struct wl_interface agl_shell_interface;

static struct agl_shell *g_shell = nullptr;

static void registry_add(void *data, wl_registry *reg, uint32_t name,
                         const char *interface, uint32_t version)
{
    if (strcmp(interface, agl_shell_interface.name) == 0) {
        g_shell = static_cast<agl_shell*>(
            wl_registry_bind(reg, name, &agl_shell_interface, 11)
        );
    }
}

static void registry_remove(void*, wl_registry*, uint32_t) {}

static const wl_registry_listener reg_listener = {
    registry_add,
    registry_remove
};

static agl_shell* bindAglShell(QPlatformNativeInterface *native)
{
    wl_display *display =
        static_cast<wl_display*>(native->nativeResourceForIntegration("display"));

    wl_registry *reg = wl_display_get_registry(display);
    wl_registry_add_listener(reg, &reg_listener, nullptr);
    wl_display_roundtrip(display);
    wl_registry_destroy(reg);

    return g_shell;
}

static wl_surface* getSurface(QPlatformNativeInterface *native, QWindow *win)
{
    return static_cast<wl_surface*>(
        native->nativeResourceForWindow("surface", win)
    );
}

static wl_output* getOutput(QPlatformNativeInterface *native, QScreen *screen)
{
    return static_cast<wl_output*>(
        native->nativeResourceForScreen("output", screen)
    );
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QPlatformNativeInterface *native = app.platformNativeInterface();

    agl_shell *shell = bindAglShell(native);
    if (!shell)
        return -1;

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/Main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    QWindow *win = qobject_cast<QWindow*>(engine.rootObjects().first());
    wl_surface *surface = getSurface(native, win);
    wl_output *output = getOutput(native, app.primaryScreen());

    // Set as background
    agl_shell_set_background(shell, surface, output);

    // Tell compositor we are ready
    QTimer::singleShot(300, [shell](){
        agl_shell_ready(shell);
    });

    return app.exec();
}
