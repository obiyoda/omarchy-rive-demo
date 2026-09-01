import QtQuick
import RiveQtQuick

Item {
  id: root

  readonly property bool ready: riveIcon.status === RiveItem.Ready
  readonly property bool failed: riveIcon.status === RiveItem.Error
  readonly property string errorString: riveIcon.errorString
  readonly property string iconAsset: Qt.resolvedUrl("assets/interactive-icon-set.riv")

  clip: true

  // The cassette/radio is column 0, row 4 of the 6x7 gallery. Keeping the
  // complete artboard alive preserves its nested Rive state machine.
  RiveItem {
    id: riveIcon
    width: root.width * 6
    height: root.height * 7
    x: 0
    y: -root.height * 4
    source: root.iconAsset
    artboard: "Artboard"
    stateMachine: "State Machine 1"
    fit: RiveItem.Fill
    interactive: iconHover.hovered
    hovered: iconHover.hovered
  }

  HoverHandler {
    id: iconHover
  }
}
