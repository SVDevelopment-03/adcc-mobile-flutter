#!/bin/sh
# Updates FLUTTER_BUILD_NAME and FLUTTER_BUILD_NUMBER in Generated.xcconfig
# and flutter_export_environment.sh from the pubspec.yaml version field.

set -e

# Accept project root as first arg, default to two levels up from this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Default to two levels up from this script (i.e. project root)
PROJECT_ROOT="${1:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
PUBSPEC="$PROJECT_ROOT/pubspec.yaml"

if [ ! -f "$PUBSPEC" ]; then
  echo "pubspec.yaml not found at $PUBSPEC"
  exit 1
fi

version_line=$(grep -E '^version:' "$PUBSPEC" | head -n1 | sed 's/version:[[:space:]]*//')
if [ -z "$version_line" ]; then
  echo "No version field found in pubspec.yaml"
  exit 1
fi

if echo "$version_line" | grep -q '+'; then
  build_name="${version_line%%+*}"
  build_number="${version_line#*+}"
else
  build_name="$version_line"
  build_number="1"
fi

XCONFIG="$SCRIPT_DIR/Generated.xcconfig"
ENV_SH="$SCRIPT_DIR/flutter_export_environment.sh"

echo "Updating iOS FLUTTER_BUILD_NAME=$build_name FLUTTER_BUILD_NUMBER=$build_number"

if [ -f "$XCONFIG" ]; then
  # Use portable sed edits for macOS
  sed -E -e "s/^FLUTTER_BUILD_NAME=.*/FLUTTER_BUILD_NAME=$build_name/" \
    -e "s/^FLUTTER_BUILD_NUMBER=.*/FLUTTER_BUILD_NUMBER=$build_number/" \
    "$XCONFIG" > "$XCONFIG.tmp" && mv "$XCONFIG.tmp" "$XCONFIG"
else
  cat > "$XCONFIG" <<EOF
// This is a generated file; do not edit or check into version control.
FLUTTER_BUILD_NAME=$build_name
FLUTTER_BUILD_NUMBER=$build_number
EOF
fi

if [ -f "$ENV_SH" ]; then
  sed -E -e "s/^export \"FLUTTER_BUILD_NAME=.*\"/export \"FLUTTER_BUILD_NAME=$build_name\"/" \
    -e "s/^export \"FLUTTER_BUILD_NUMBER=.*\"/export \"FLUTTER_BUILD_NUMBER=$build_number\"/" \
    "$ENV_SH" > "$ENV_SH.tmp" && mv "$ENV_SH.tmp" "$ENV_SH"
fi

echo "Done."
