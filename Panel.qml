import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import RiveQtQuick

Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool opened: false
  property string currentDemo: "icons"

  readonly property string pluginId: manifest && manifest.id
    ? manifest.id
    : "obiyoda.rive-demo"
  readonly property string currentAsset: currentDemo === "audio"
    ? Qt.resolvedUrl("assets/audio-player.riv")
    : Qt.resolvedUrl("assets/interactive-icon-set.riv")
  readonly property string currentArtboard: currentDemo === "audio"
    ? "Audio Player"
    : "Artboard"
  readonly property string currentStateMachine: "State Machine 1"
  readonly property string currentHelp: currentDemo === "audio"
    ? "Press Play, Pause, Stop, or drag the dial. Audio is decoded by Rive's native engine."
    : "Move and click across the grid. All 42 icons are interactive nested Rive artboards."

  function open(payloadJson) {
    let payload = {}
    try { payload = JSON.parse(payloadJson || "{}") || {} } catch (error) {}
    currentDemo = payload.demo === "audio" ? "audio" : "icons"
    opened = true
    Qt.callLater(function() {
      if (root.opened) keyCatcher.forceActiveFocus()
    })
  }

  function close() {
    opened = false
  }

  function requestClose() {
    if (shell && typeof shell.hide === "function") shell.hide(pluginId)
    else close()
  }

  PanelWindow {
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "obiyoda-rive-demo"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Rectangle {
      anchors.fill: parent
      color: Qt.rgba(0, 0, 0, 0.76)

      MouseArea {
        anchors.fill: parent
        onClicked: root.requestClose()
      }
    }

    Item {
      id: keyCatcher
      anchors.fill: parent
      focus: true

      Keys.onEscapePressed: root.requestClose()

      Item {
        anchors.centerIn: parent
        width: 1040
        height: 760
        scale: Math.min(1,
          (keyCatcher.width - 40) / width,
          (keyCatcher.height - 40) / height)

        MouseArea { anchors.fill: parent; onClicked: {} }

        Rectangle {
          anchors.fill: parent
          radius: 18
          color: "#0b1118"
          border.width: 1
          border.color: rive.status === 2 ? "#334155" : "#475569"

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
              Layout.fillWidth: true
              spacing: 12

              ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                  text: "Rive × Omarchy"
                  color: "#f8fafc"
                  font.family: "monospace"
                  font.pixelSize: 22
                  font.bold: true
                }

                Text {
                  text: rive.status === 2
                    ? "Native C++ · " + rive.currentArtboard + " · " + rive.currentStateMachine
                    : (rive.errorString || "Loading native Rive runtime…")
                  color: rive.status === 3 ? "#fca5a5" : "#94a3b8"
                  font.family: "monospace"
                  font.pixelSize: 13
                }
              }

              Button {
                id: closeButton
                text: "Close"
                onClicked: root.requestClose()
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 8

              Button {
                text: "Interactive icons"
                font.bold: root.currentDemo === "icons"
                onClicked: root.currentDemo = "icons"
              }

              Button {
                text: "Audio player"
                font.bold: root.currentDemo === "audio"
                onClicked: root.currentDemo = "audio"
              }

              Item { Layout.fillWidth: true }

              Text {
                text: "No browser · No WebEngine · Native Wayland surface"
                color: "#64748b"
                font.family: "monospace"
                font.pixelSize: 12
              }
            }

            Rectangle {
              Layout.fillWidth: true
              Layout.fillHeight: true
              radius: 14
              color: "#f5f5f4"
              clip: true

              RiveItem {
                id: rive
                anchors.fill: parent
                anchors.margins: 12
                source: root.opened ? root.currentAsset : ""
                artboard: root.currentArtboard
                stateMachine: root.currentStateMachine
                fit: RiveItem.Contain
                interactive: true
              }
            }

            Text {
              Layout.fillWidth: true
              text: root.currentHelp
              color: "#94a3b8"
              wrapMode: Text.Wrap
              horizontalAlignment: Text.AlignHCenter
              font.pixelSize: 13
            }
          }
        }
      }
    }
  }
}
