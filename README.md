# Native Rive Demo for Omarchy

An Omarchy panel demonstrating interactive Rive files rendered directly through a native Qt Quick module. It includes an interactive 42-icon grid and an audio-player example with embedded tracks.

There is no browser, WebAssembly, or Qt WebEngine layer. Quickshell owns the native Wayland window and `RiveItem` renders through the official Rive C++ runtime.

## Requirements

- Omarchy with Qt 6.11 and Quickshell 0.3
- The `RiveQtQuick` native QML module installed for the active Qt version

The native module is deliberately distributed separately from the QML plugin because it must be rebuilt when Omarchy updates Qt's private scene-graph ABI.

## Install

Build and install the native runtime first:

```bash
git clone https://github.com/obiyoda/rive-qtquick-omarchy.git
cd rive-qtquick-omarchy
scripts/bootstrap.sh
scripts/build.sh
scripts/install-runtime.sh
```

Then add and enable the demo plugin:

```bash
omarchy plugin add https://github.com/obiyoda/omarchy-rive-demo.git --enable
omarchy-shell shell summon obiyoda.rive-demo '{}'
```

Place its experimental native Rive widget in the top bar:

```bash
omarchy bar move obiyoda.rive-demo --before omarchy.audio
```

The cassette icon is a live crop of the interactive Rive icon artboard. Left-click opens the audio player; right-click opens the complete icon gallery.

Open a specific example directly:

```bash
omarchy-shell shell summon obiyoda.rive-demo '{"demo":"icons"}'
omarchy-shell shell summon obiyoda.rive-demo '{"demo":"audio"}'
```

Review [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the bundled Rive artwork attribution.
