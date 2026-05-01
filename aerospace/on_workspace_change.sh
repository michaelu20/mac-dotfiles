#!/bin/bash
# Notify Sketchybar
/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"

# Simple enforcement: if Antinote is on the current workspace, snap its size
ANTINOTE_WID=$(/opt/homebrew/bin/aerospace list-windows --workspace "$AEROSPACE_FOCUSED_WORKSPACE" --app-bundle-id com.chabomakers.Antinote --format "%{window-id}")

if [ ! -z "$ANTINOTE_WID" ]; then
    sleep 0.2
    osascript -e 'tell application "System Events" to tell process "Antinote" to set size of window 1 to {500, 500}'
fi
