pragma ComponentBehavior: Bound

import "popouts" as BarPopouts
import "components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.services
import qs.config

Item {
    id: root

    required property ShellScreen screen
    required property DrawerVisibilities visibilities
    required property BarPopouts.Wrapper popouts
    required property bool fullscreen
    readonly property int hPadding: Appearance.padding.large
    readonly property int spacing: Appearance.spacing.normal

    function closeTray(): void {
        if (!Config.bar.tray.compact)
            return;

        const tray = trayLoader.item as Tray;
        if (tray)
            tray.expanded = false;
    }

    function within(item, x: real): bool {
        if (!item || !item.visible)
            return false;

        const left = item.mapToItem(root, 0, 0).x;
        return x >= left && x <= left + item.width;
    }

    function checkPopout(x: real): void {
        const tray = trayLoader.item as Tray;
        const statusIcons = statusIconsLoader.item as StatusIcons;
        const activeWindow = activeWindowLoader.item as Item;

        if (!within(trayLoader, x))
            closeTray();

        if (statusIcons && within(statusIconsLoader, x) && Config.bar.popouts.statusIcons) {
            const local = mapToItem(statusIcons.items, x, 0);
            const icon = statusIcons.items.childAt(local.x, statusIcons.items.height / 2);
            if (icon) {
                popouts.currentName = icon.name;
                popouts.currentCenter = Qt.binding(() => icon.mapToItem(root, icon.implicitWidth / 2, 0).x);
                popouts.hasCurrent = true;
                return;
            }
        } else if (tray && within(trayLoader, x) && Config.bar.popouts.tray) {
            const local = mapToItem(tray, x, tray.implicitHeight / 2);
            if (!Config.bar.tray.compact || (tray.expanded && !tray.expandIcon.contains(mapToItem(tray.expandIcon, x, tray.implicitHeight / 2)))) {
                const index = Math.floor(((local.x - tray.padding * 2 + tray.spacing) / tray.layout.implicitWidth) * tray.items.count);
                const trayItem = tray.items.itemAt(index);
                if (trayItem) {
                    popouts.currentName = `traymenu${index}`;
                    popouts.currentCenter = Qt.binding(() => trayItem.mapToItem(root, trayItem.implicitWidth / 2, 0).x);
                    popouts.hasCurrent = true;
                    return;
                }
            } else {
                popouts.hasCurrent = false;
                tray.expanded = true;
                return;
            }
        } else if (activeWindow && within(activeWindow, x) && Config.bar.popouts.activeWindow && Config.bar.activeWindow.showOnHover) {
            popouts.currentName = "activewindow";
            popouts.currentCenter = activeWindow.mapToItem(root, activeWindow.implicitWidth / 2, 0).x ?? 0;
            popouts.hasCurrent = true;
            return;
        }

        popouts.hasCurrent = false;
    }

    function handleWheel(x: real, angleDelta: point): void {
        if (x < screen.width / 2 && Config.bar.scrollActions.volume) {
            if (angleDelta.y > 0)
                Audio.incrementVolume();
            else if (angleDelta.y < 0)
                Audio.decrementVolume();
        } else if (Config.bar.scrollActions.brightness) {
            const monitor = Brightness.getMonitorForScreen(screen);
            if (angleDelta.y > 0)
                monitor.setBrightness(monitor.brightness + Config.services.brightnessIncrement);
            else if (angleDelta.y < 0)
                monitor.setBrightness(monitor.brightness - Config.services.brightnessIncrement);
        }
    }

    Row {
        id: leftRow

        anchors.left: parent.left
        anchors.leftMargin: root.hPadding
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.spacing

        Loader {
            id: logoLoader

            asynchronous: true
            active: !root.fullscreen
            visible: active
            sourceComponent: OsIcon {}
        }

        Loader {
            id: activeWindowLoader

            asynchronous: true
            active: !root.fullscreen
            visible: active
            sourceComponent: ActiveWindow {
                bar: root
                monitor: Brightness.getMonitorForScreen(root.screen)
                maxWidthOverride: Math.max(0, centerClock.x - leftRow.x - logoLoader.implicitWidth - root.spacing * 3)
            }
        }
    }

    Loader {
        id: centerClock

        anchors.centerIn: parent
        asynchronous: true
        active: !root.fullscreen
        visible: active
        sourceComponent: Clock {}
    }

    Row {
        id: rightRow

        anchors.right: parent.right
        anchors.rightMargin: root.hPadding
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.spacing

        Loader {
            id: trayLoader

            asynchronous: true
            active: !root.fullscreen
            visible: active
            sourceComponent: Tray {}
        }

        Loader {
            id: statusIconsLoader

            asynchronous: true
            active: !root.fullscreen
            visible: active
            sourceComponent: StatusIcons {}
        }

        Loader {
            id: powerLoader

            asynchronous: true
            active: true
            visible: active
            sourceComponent: Power {
                visibilities: root.visibilities
            }
        }
    }
}
