import QtQuick

Item {
  id: root

  property var bar: null
  property string moduleName: "obiyoda.rive-demo"
  property var settings: ({})

  readonly property real slotSize: bar ? bar.barSize : 26
  readonly property real iconSize: Math.max(20, slotSize - 2)

  implicitWidth: slotSize
  implicitHeight: slotSize

  NativeIcon {
    anchors.centerIn: parent
    width: root.iconSize
    height: root.iconSize
  }

  MouseArea {
    anchors.fill: parent
    z: 100
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    preventStealing: true
    propagateComposedEvents: false

    onContainsMouseChanged: {
      if (!root.bar) return
      if (containsMouse) root.bar.showTooltip(root, "Sprout · click to say hello")
      else root.bar.hideTooltip(root)
    }

    onClicked: {
      if (root.bar && root.bar.shell)
        root.bar.shell.summon(root.moduleName, "{}")
    }
  }
}
