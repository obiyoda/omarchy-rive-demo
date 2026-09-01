#!/usr/bin/env bash
set -euo pipefail

readonly project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly runtime_root="${RIVE_OMARCHY_QML_PATH:-${HOME}/.local/lib/rive-omarchy/qml}"

if command -v qmltestrunner >/dev/null 2>&1; then
  readonly qml_test_runner="$(command -v qmltestrunner)"
elif [[ -x /usr/lib/qt6/bin/qmltestrunner ]]; then
  readonly qml_test_runner=/usr/lib/qt6/bin/qmltestrunner
else
  echo "Missing qmltestrunner; install qt6-declarative." >&2
  exit 2
fi

if [[ ! -f "${runtime_root}/RiveQtQuick/qmldir" ]]; then
  echo "RiveQtQuick is not installed at ${runtime_root}/RiveQtQuick" >&2
  echo "Install https://github.com/obiyoda/rive-qtquick-omarchy first." >&2
  exit 2
fi

omarchy plugin validate "${project_root}"

env \
  QT_QPA_PLATFORM=offscreen \
  QT_QUICK_BACKEND=software \
  QML_IMPORT_PATH="${runtime_root}${QML_IMPORT_PATH:+:${QML_IMPORT_PATH}}" \
  "${qml_test_runner}" -input "${project_root}/tests"
