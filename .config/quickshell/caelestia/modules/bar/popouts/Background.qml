import QtQuick
import QtQuick.Shapes
import qs.config
import qs.services

ShapePath {
    id: root

    required property Wrapper wrapper
    required property bool invertBottomRounding
    readonly property real rounding: wrapper.isDetached ? Appearance.rounding.normal : Config.border.rounding
    property real opacity: wrapper.implicitWidth > 0 ? 1 : 0

    strokeWidth: -1
    fillColor: Qt.alpha(Colours.palette.m3surface, opacity)

    PathMove {
        x: startX + root.rounding
        y: startY
    }
    PathLine {
        x: startX + root.wrapper.width - root.rounding
        y: startY
    }
    PathArc {
        x: startX + root.wrapper.width
        y: startY + root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.width / 2)
        radiusY: root.rounding
    }
    PathLine {
        x: startX + root.wrapper.width
        y: startY + root.wrapper.height - root.rounding
    }
    PathArc {
        x: startX + root.wrapper.width - root.rounding
        y: startY + root.wrapper.height
        radiusX: Math.min(root.rounding, root.wrapper.width / 2)
        radiusY: root.rounding
    }
    PathLine {
        x: startX + root.rounding
        y: startY + root.wrapper.height
    }
    PathArc {
        x: startX
        y: startY + root.wrapper.height - root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.width / 2)
        radiusY: root.rounding
    }
    PathLine {
        x: startX
        y: startY + root.rounding
    }
    PathArc {
        x: startX + root.rounding
        y: startY
        radiusX: Math.min(root.rounding, root.wrapper.width / 2)
        radiusY: root.rounding
    }
}
