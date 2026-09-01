import QtQuick
import Quickshell
import Quickshell.Wayland
import RiveQtQuick

Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool opened: false
  property bool backgroundAudio: false
  property bool closePending: false

  readonly property string pluginId: manifest && manifest.id
    ? manifest.id
    : "obiyoda.rive-demo"
  readonly property string sproutAsset: Qt.resolvedUrl("assets/sprout.riv")

  function open(payloadJson) {
    closeTimer.stop()
    closePending = false

    if (payloadJson) {
      try {
        const payload = JSON.parse(payloadJson)
        if (typeof payload.backgroundAudio === "boolean")
          backgroundAudio = payload.backgroundAudio
      } catch (error) {
        console.warn("Rive Sprout ignored an invalid open payload:", error)
      }
    }

    opened = true
    Qt.callLater(function() {
      if (root.opened) keyCatcher.forceActiveFocus()
    })
  }

  function close() {
    if (!opened) return

    if (backgroundAudio) {
      closePending = false
      opened = false
      return
    }

    // Rive audio is owned by the render-thread artboard, so give the native
    // stop command one visible frame to run before hiding the layer surface.
    closePending = true
    sprout.stopAudio()
    closeTimer.restart()
  }

  function requestClose() {
    if (shell && typeof shell.hide === "function") shell.hide(pluginId)
    else close()
  }

  function audioPolicy() {
    return backgroundAudio ? "background" : "stop-on-close"
  }

  Timer {
    id: closeTimer
    interval: 50
    repeat: false
    onTriggered: root.opened = false
  }

  PanelWindow {
    id: panel
    // Background mode keeps the artboard (and therefore its authored audio)
    // alive in a transparent, input-free layer surface after the card closes.
    visible: root.opened || root.backgroundAudio
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    mask: Region {
      width: root.opened ? panel.width : 0
      height: root.opened ? panel.height : 0
    }

    WlrLayershell.namespace: "obiyoda-rive-sprout"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: root.opened
      ? WlrKeyboardFocus.Exclusive
      : WlrKeyboardFocus.None

    Rectangle {
      anchors.fill: parent
      opacity: root.opened ? 1 : 0
      enabled: root.opened
      color: Qt.rgba(0, 0, 0, 0.48)

      TapHandler { onTapped: root.requestClose() }
    }

    Item {
      id: keyCatcher
      anchors.fill: parent
      opacity: root.opened ? 1 : 0
      enabled: root.opened
      focus: root.opened

      Keys.onEscapePressed: root.requestClose()

      Item {
        anchors.centerIn: parent
        width: Math.min(560, keyCatcher.width - 40, keyCatcher.height - 40)
        height: width

        TapHandler { onTapped: {} }

        Rectangle {
          anchors.fill: parent
          radius: 30
          color: "#e9eadf"
          border.width: 1
          border.color: "#8ba164"
          clip: true

          RiveItem {
            id: sprout
            anchors.fill: parent
            anchors.margins: 8
            source: root.sproutAsset
            artboard: "mascot"
            stateMachine: "State Machine 1"
            fit: RiveItem.Contain
            interactive: true
            playing: root.opened
            audioVolume: root.closePending ? 0 : 1
          }

          Text {
            anchors.centerIn: parent
            visible: sprout.status === RiveItem.Error
            text: sprout.errorString || "Sprout could not load"
            color: "#991b1b"
            font.pixelSize: 14
          }
        }

        Rectangle {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.margins: 14
          width: audioLabel.implicitWidth + 26
          height: 34
          radius: 17
          color: audioHover.hovered ? "#33472c" : "#24341f"
          border.width: 1
          border.color: root.backgroundAudio ? "#bef264" : "#8ba164"

          Text {
            id: audioLabel
            anchors.centerIn: parent
            text: root.backgroundAudio ? "♫ Background on" : "♫ Stops on close"
            color: "#f7fee7"
            font.pixelSize: 13
          }

          HoverHandler { id: audioHover }
          TapHandler {
            onTapped: root.backgroundAudio = !root.backgroundAudio
          }
        }

        Rectangle {
          anchors.top: parent.top
          anchors.right: parent.right
          anchors.margins: 14
          width: 34
          height: 34
          radius: 17
          color: closeHover.hovered ? "#33472c" : "#24341f"
          border.width: 1
          border.color: "#8ba164"

          Text {
            anchors.centerIn: parent
            text: "×"
            color: "#f7fee7"
            font.pixelSize: 22
          }

          HoverHandler { id: closeHover }
          TapHandler { onTapped: root.requestClose() }
        }
      }
    }
  }
}
