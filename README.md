# Rive Sprout for Omarchy

Rive Sprout is a tiny animated companion rendered natively inside Omarchy and
Quickshell. The bar contains a live Rive animation; clicking it opens the full
interactive character on a native Wayland layer surface.

There is no browser, WebAssembly, Flutter window, or Qt WebEngine layer.
Quickshell owns the surface and the official Rive C++ runtime draws it through
a Qt Quick item.

## What this demonstrates

- a continuously animated Rive file embedded in the Omarchy top bar;
- a transparent Quickshell input layer above a display-only Rive item;
- an interactive Rive state machine in a desktop panel;
- embedded Rive audio with explicit stop-on-close/background policy; and
- native handling for responsive artboards and otherwise blank advanced-blend
  Marketplace files.

## Requirements

- Omarchy on x86-64 Arch Linux;
- Qt 6.11 and Quickshell 0.3; and
- the separately installed `RiveQtQuick` native QML module.

The native module uses Qt private scene-graph APIs. Rebuild it after an Omarchy
update changes the installed Qt minor version.

## Install

Install the build prerequisites:

```bash
omarchy pkg add base-devel cmake ninja clang python git qt6-base qt6-declarative
```

Build and install the native runtime:

```bash
git clone https://github.com/obiyoda/rive-qtquick-omarchy.git
cd rive-qtquick-omarchy
scripts/bootstrap.sh
scripts/build.sh
scripts/install-runtime.sh
cd ..
```

Install Sprout and place it before Omarchy's audio widget:

```bash
omarchy plugin add https://github.com/obiyoda/omarchy-rive-demo.git --enable
omarchy bar move obiyoda.rive-demo --before omarchy.audio
```

Click Sprout in the bar. Its authored audio plays only in the large panel by
default and stops when the panel closes. The audio button opts into background
playback.

## Open and close from the command line

```bash
omarchy-shell shell summon obiyoda.rive-demo '{}'
omarchy-shell shell hide obiyoda.rive-demo
```

Open it with background playback already enabled:

```bash
omarchy-shell shell summon obiyoda.rive-demo '{"backgroundAudio":true}'
```

## Test or modify the plugin

With the native runtime installed:

```bash
scripts/test.sh
```

See [DEVELOPMENT.md](DEVELOPMENT.md) for the bar-input contract, audio
lifecycle, live smoke test, and a checklist for trying another `.riv` file.

The native bridge, build patches, and blank-render diagnostic live in
[`obiyoda/rive-qtquick-omarchy`](https://github.com/obiyoda/rive-qtquick-omarchy).

## Troubleshooting

### `module "RiveQtQuick" is not installed`

Rebuild and reinstall the native runtime. Confirm that
`~/.local/lib/rive-omarchy/qml/RiveQtQuick/qmldir` exists, then restart the
shell with `omarchy restart shell`.

### It stopped working after an Omarchy update

Compare `qmake6 -query QT_VERSION` with the version in the runtime README. A Qt
minor-version change requires rebuilding and reinstalling the module.

### The bar animates but clicking does nothing

Run `scripts/test.sh`. The regression test verifies the transparent input layer
and direct in-process summon path. Rescan an installed development copy with
`omarchy-shell shell rescanPlugins`.

### A different Marketplace file renders blank

Use `scripts/diagnose-riv-render.sh` from the native runtime repository. Some
advanced blend modes need its compatibility fallback; the diagnostic rejects a
missing or uniformly blank capture.

### Audio continues after closing

The panel's audio button intentionally enables background playback. Set it to
“Stops on close” for the default lifecycle.

## Artwork and license

The bundled Marketplace artwork is redistributed under CC BY 4.0. See
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for creator attribution.
Plugin code is MIT licensed.
