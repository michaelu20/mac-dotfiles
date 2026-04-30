#!/bin/bash

# Get disk usage for the root partition
USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

case $USAGE in
  9[0-9]|100) COLOR="0xfff38ba8" ;; # Red
  [7-8][0-9]) COLOR="0xfffab387" ;; # Orange
  *) COLOR="0xffa6e3a1" ;;          # Green
esac

sketchybar --set "$NAME" label="$USAGE%" icon.color="$COLOR"
