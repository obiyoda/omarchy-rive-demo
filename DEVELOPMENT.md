# Developing Rive Sprout

This repository is an Omarchy shell plugin. It contains QML and a licensed
`.riv` asset; the native C++ QML module lives in
[`obiyoda/rive-qtquick-omarchy`](https://github.com/obiyoda/rive-qtquick-omarchy).

## File map

- `Widget.qml` owns the bar slot and all pointer input.
- `NativeIcon.qml` renders a silent, display-only crop in that slot.
- `Panel.qml` owns the desktop layer surface, interactive artboard, and audio
  lifecycle.
- `assets/sprout.riv` is the attributed Marketplace file.
- `tests/tst_sprout_widget_click.qml` locks down the bar click path.

## Contracts to preserve

### Bar input stays above Rive

`RiveItem` currently accepts native Qt mouse events even when
`interactive: false`. Keep `Widget.qml`'s transparent `MouseArea` stacked above
`NativeIcon`; a parent `TapHandler` can lose the click to the child Rive item.

The bar action calls `bar.shell.summon()` in-process. Keep that direct route so
opening the panel does not depend on spawning another `omarchy-shell` process.

### The bar is silent

The bar artboard uses `audioVolume: 0`. Audio belongs to the panel instance,
where the user can choose between stop-on-close and background playback.

For stop-on-close, call `stopAudio()` and keep the panel surface visible for at
least one render frame before hiding it. The native command is consumed on the
Qt Quick render thread.

### Assets remain attributable

When replacing or adding a `.riv` file, record its creator, canonical source,
license, and any modifications in `THIRD_PARTY_NOTICES.md`. Confirm that its
license permits redistribution before committing the binary.

## Tight test loop

Install the native runtime, then run:

```bash
scripts/test.sh
```

The command validates the plugin manifest and uses the real `Widget.qml` with a
fake Omarchy bar. It must prove that one click produces exactly one in-process
summon and no external `bar.run()` call.

For a live smoke test after installing the plugin:

```bash
omarchy-shell shell rescanPlugins
omarchy-shell shell summon obiyoda.rive-demo '{}'
omarchy-shell shell hide obiyoda.rive-demo
```

## Trying another Rive file

1. Put the file under `assets/` and update `THIRD_PARTY_NOTICES.md`.
2. Set its `source`, `artboard`, and `stateMachine` in `NativeIcon.qml` and
   `Panel.qml`.
3. Keep the bar instance display-only and silent.
4. Use the runtime repository's render diagnostic against both OpenGL and
   software when the asset matters on both backends.
5. Run `scripts/test.sh`, then test clicking, closing, Escape, and both audio
   policies in the live shell.

## Release completion

A plugin change is complete when:

- `scripts/test.sh` passes;
- `omarchy plugin validate .` passes;
- the installed bar icon opens the panel by clicking;
- default close stops authored audio and background mode remains intentional;
- `THIRD_PARTY_NOTICES.md` covers every committed `.riv` file; and
- the version in `manifest.json` reflects the release.
