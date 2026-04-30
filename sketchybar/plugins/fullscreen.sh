#!/bin/bash

SB="/opt/homebrew/bin/sketchybar"
AS="/opt/homebrew/bin/aerospace"

# Check if focused window is actually fullscreen
# "fullscreen on --fail-if-noop" exits 1 if already fullscreen
$AS fullscreen on --fail-if-noop >/dev/null 2>&1
if [ $? -eq 1 ]; then
  # Already fullscreen — show indicator
  $SB --set fullscreen_indicator drawing=on
else
  # Wasn't fullscreen — we just accidentally toggled it on, undo it
  $AS fullscreen off >/dev/null 2>&1
  $SB --set fullscreen_indicator drawing=off
fi
