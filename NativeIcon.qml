import QtQuick
import RiveQtQuick

Item {
  id: root

  readonly property string sproutAsset: Qt.resolvedUrl("assets/sprout.riv")

  clip: true

  RiveItem {
    width: root.width * 3
    height: root.height * 3
    x: -root.width
    y: -root.height
    source: root.sproutAsset
    artboard: "mascot"
    stateMachine: "State Machine 1"
    fit: RiveItem.Fill
    interactive: false
    audioVolume: 0
  }
}
