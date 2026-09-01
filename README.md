# Native Rive Demo for Omarchy

An Omarchy panel demonstrating interactive Rive files rendered directly through a native Qt Quick module. It includes an interactive 42-icon grid and an audio-player example with embedded tracks.

There is no browser, WebAssembly, or Qt WebEngine layer. Quickshell owns the native Wayland window and `RiveItem` renders through the official Rive C++ runtime.

## Requirements

- Omarchy with Qt 6.11 and Quickshell 0.3
- The `RiveQtQuick` native QML module installed for the active Qt version

The native module is deliberately distributed separately from the QML plugin because it must be rebuilt when Omarchy updates Qt's private scene-graph ABI.

## Install

Once the runtime package is installed and this directory has been published as the standalone `obiyoda/omarchy-rive-demo` repository, add and enable it:

```bash
omarchy plugin add https://github.com/obiyoda/omarchy-rive-demo.git --enable
omarchy-shell shell summon obiyoda.rive-demo '{}'
```

Open a specific example directly:

```bash
omarchy-shell shell summon obiyoda.rive-demo '{"demo":"icons"}'
omarchy-shell shell summon obiyoda.rive-demo '{"demo":"audio"}'
```

Review [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the bundled Rive artwork attribution.
