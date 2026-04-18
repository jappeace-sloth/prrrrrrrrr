#!/usr/bin/env bash
# Set up the iOS Xcode project for prrrrrrrrr.
# Requires macOS with Xcode, xcodegen, and Nix installed.
#
# Builds the Haskell library for a real iOS device via Nix, stages
# the result with Swift bridge sources, and generates an Xcode project.
# Open the project in Xcode to build, sign, and deploy to your device.
#
# Usage:
#   ./setup-ios.sh
#
# After running, open the printed .xcodeproj path in Xcode.

set -euo pipefail

[ -z "${PRRRRRRRRR_API_KEY:-}" ] && echo "Set PRRRRRRRRR_API_KEY" && exit 1

REPO_DIR="$(pwd)"
sed -i '' "s/PRRRRRRRRR_API_KEY/$PRRRRRRRRR_API_KEY/" src/GymTracker/Config.hs
trap 'cd "$REPO_DIR" && git checkout src/GymTracker/Config.hs' EXIT

result=$(nix-build nix/ios-device-app.nix)

# Stage the Xcode project in a persistent local directory
WORKDIR="$REPO_DIR/ios-build"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cp -r "$result/share/ios/." "$WORKDIR/"
chmod -R u+w "$WORKDIR"

cd "$WORKDIR"
xcodegen generate

echo ""
echo "Xcode project ready at: $WORKDIR/Hatter.xcodeproj"
echo "Open with:  open $WORKDIR/Hatter.xcodeproj"
