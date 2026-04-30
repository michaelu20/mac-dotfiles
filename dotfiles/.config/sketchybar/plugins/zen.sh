#!/bin/bash
SB="/opt/homebrew/bin/sketchybar"
JQ="/opt/homebrew/bin/jq"

# Colors (matching sketchybarrc)
BAR_COLOR=0xff1e1e2e
TRANSPARENT=0x00000000

# Check if ANY item is hidden to determine current state
# We use clock as our "canary"
CURRENT_DRAWING_STATE=$($SB --query clock | $JQ -r '.geometry.drawing')

if [ "$1" = "on" ]; then
    ACTION="hide"
elif [ "$1" = "off" ]; then
    ACTION="show"
else
    # If clock is ON, we want to HIDE everything
    if [ "$CURRENT_DRAWING_STATE" = "on" ]; then
        ACTION="hide"
    else
        ACTION="show"
    fi
fi

if [ "$ACTION" = "hide" ]; then
  # Hide all items (using --set --all)
  $SB --set "/.*/" drawing=off
  
  # Keep only zen_mode visible
  $SB --set zen_mode drawing=on \
                     label="ZEN" \
                     icon.color=0xffa6e3a1
  
  # Make the bar transparent
  $SB --bar color=$TRANSPARENT blur_radius=0
else
  # Show all items
  $SB --set "/.*/" drawing=on
  
  # Specifically hide indicators that are meant to be conditional
  $SB --set fullscreen_indicator drawing=off
  $SB --set "/apps\..*/" drawing=off
  
  # Reset zen_mode
  $SB --set zen_mode label="" \
                     icon.color=0xffcba6f7
  
  # Restore the bar
  $SB --bar color=$BAR_COLOR blur_radius=30
  
  # Trigger workspace update to ensure dots/icons/apps reappear correctly
  $SB --trigger aerospace_workspace_change
fi
