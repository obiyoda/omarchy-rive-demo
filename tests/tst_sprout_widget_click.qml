import QtQuick
import QtTest
import ".." as Sprout

Item {
  width: 80
  height: 80

  QtObject {
    id: fakeShell

    property int summonCalls: 0
    property string lastPluginId: ""
    property string lastPayload: ""

    function summon(pluginId, payload) {
      summonCalls++
      lastPluginId = pluginId
      lastPayload = payload
      return true
    }
  }

  QtObject {
    id: fakeBar

    property real barSize: 26
    property var shell: fakeShell
    property int runCalls: 0

    function run(_command) {
      runCalls++
    }

    function showTooltip() {}
    function hideTooltip() {}
  }

  Sprout.Widget {
    id: widget
    bar: fakeBar
    width: implicitWidth
    height: implicitHeight
  }

  TestCase {
    name: "SproutWidgetClick"
    when: windowShown

    function test_click_reaches_bar_action() {
      fakeShell.summonCalls = 0
      fakeShell.lastPluginId = ""
      fakeShell.lastPayload = ""
      fakeBar.runCalls = 0

      mouseClick(widget, widget.width / 2, widget.height / 2, Qt.LeftButton)

      compare(fakeShell.summonCalls, 1)
      compare(fakeShell.lastPluginId, "obiyoda.rive-demo")
      compare(fakeShell.lastPayload, "{}")
      compare(fakeBar.runCalls, 0)
    }
  }
}
