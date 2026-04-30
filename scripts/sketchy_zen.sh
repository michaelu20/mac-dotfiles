#!/bin/bash

# Items to hide in Zen Mode
ITEMS=("clock" "battery" "disk" "volume")

# Check current state (using clock as reference)
STATE=$(sketchybar --query clock | jq -r '.drawing')

if [ "$STATE" = "on" ]; then
  # Turn Zen Mode ON
  for item in "${ITEMS[@]}"; do
    sketchybar --set "$item" drawing=off
  done
  sketchybar --set zen_mode label="ZEN" icon.color=0xffa6e3a1
else
  # Turn Zen Mode OFF
  for item in "${ITEMS[@]}"; do
    sketchybar --set "$item" drawing=on
  done
  sketchybar --set zen_mode label="" icon.color=0xffcba6f7
fi
