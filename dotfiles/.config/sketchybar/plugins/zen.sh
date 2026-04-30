#!/bin/bash
SB="/opt/homebrew/bin/sketchybar"
JQ="/opt/homebrew/bin/jq"

# Items to hide (Stats + Workspaces + Apps)
ITEMS=("clock" "battery" "disk" "volume" "front_app" "apple.logo")
SPACES=("space.1" "space.2" "space.3" "space.4" "space.5")
APPS=("apps.1" "apps.2" "apps.3" "apps.4" "apps.5")

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
  for item in "${ITEMS[@]}" "${SPACES[@]}" "${APPS[@]}"; do
    $SB --set "$item" drawing=off
  done
  $SB --set zen_mode icon.color=0xffa6e3a1
else
  for item in "${ITEMS[@]}" "${SPACES[@]}" "${APPS[@]}"; do
    $SB --set "$item" drawing=on
  done
  $SB --set zen_mode icon.color=0xffcba6f7
  # Trigger workspace update to ensure dots/icons reappear correctly
  $SB --trigger aerospace_workspace_change
fi
