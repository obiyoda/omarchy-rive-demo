import QtQuick

// PROTOTYPE: crop one nested icon from the 6x7 gallery to prove that a
// native Rive surface can live inside Omarchy's real status bar.
Item {
  id: root

  property var bar: null
  property string moduleName: "obiyoda.rive-demo"
  property var settings: ({})

  readonly property real slotSize: bar ? bar.barSize : 26
  readonly property real iconSize: Math.max(18, slotSize - 4)

  implicitWidth: bar && bar.vertical ? slotSize : 112
  implicitHeight: slotSize

  function openDemo(name) {
    if (!bar) return
    bar.run("omarchy-shell shell summon obiyoda.rive-demo '{\"demo\":\"" + name + "\"}'")
  }

  Row {
    anchors.centerIn: parent
    spacing: 6

    Item {
      id: iconViewport
      width: root.iconSize
      height: root.iconSize
      clip: true

      Loader {
        id: iconLoader
        anchors.fill: parent
        source: Qt.resolvedUrl("NativeIcon.qml")
      }
    }

    Column {
      visible: !(root.bar && root.bar.vertical)
      anchors.verticalCenter: parent.verticalCenter
      spacing: 0

      Text {
        text: "RIVE RADIO"
        color: root.bar ? root.bar.foreground : "white"
        font.family: root.bar ? root.bar.fontFamily : "monospace"
        font.pixelSize: 10
        font.bold: true
      }

      Text {
        text: iconLoader.status === Loader.Ready && iconLoader.item && iconLoader.item.ready
          ? "native · ready"
          : (iconLoader.status === Loader.Error || (iconLoader.item && iconLoader.item.failed) ? "native · error" : "loading…")
        color: iconLoader.status === Loader.Error || (iconLoader.item && iconLoader.item.failed)
          ? "#fb7185"
          : Qt.darker(root.bar ? root.bar.foreground : "white", 1.45)
        font.family: root.bar ? root.bar.fontFamily : "monospace"
        font.pixelSize: 8
      }
    }
  }

  HoverHandler {
    id: widgetHover
    onHoveredChanged: {
      if (!root.bar) return
      if (hovered) root.bar.showTooltip(root, "Rive Radio · left: player · right: icon gallery")
      else root.bar.hideTooltip(root)
    }
  }

  TapHandler {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onTapped: function(eventPoint, button) {
      root.openDemo(button === Qt.RightButton ? "icons" : "audio")
    }
  }
}
