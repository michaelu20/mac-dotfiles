#!/bin/bash

ACTION="$1"
APP=$(cat /tmp/sketchybar_media_app 2>/dev/null)

control_app() {
  local cmd="$1"
  case "$APP" in
    "Spotify") osascript -e "tell application \"Spotify\" to $cmd" ;;
    "Music")   osascript -e "tell application \"Music\" to $cmd" ;;
    *)         osascript -e "tell application \"$APP\" to $cmd" 2>/dev/null || true ;;
  esac
}

case "$ACTION" in
  prev) control_app "previous track" ;;
  next) control_app "next track" ;;
  toggle)
    EXPANDED=$(cat /tmp/sketchybar_media_expanded 2>/dev/null || echo "0")
    if [ "$EXPANDED" = "1" ]; then
      echo "0" > /tmp/sketchybar_media_expanded
      sketchybar --set media label.drawing=off
      sketchybar --set media.prev drawing=off
      sketchybar --set media.play drawing=off
      sketchybar --set media.next drawing=off
    else
      echo "1" > /tmp/sketchybar_media_expanded
      STATE=$(cat /tmp/sketchybar_media_state 2>/dev/null)
      LABEL=$(sketchybar --query media 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['label']['value'])" 2>/dev/null)
      sketchybar --set media label.drawing=on
      sketchybar --set media.prev drawing=on
      sketchybar --set media.play drawing=on
      sketchybar --set media.next drawing=on
      sketchybar --trigger forced
    fi
    ;;
  play)
    control_app "playpause"
    sleep 0.15
    NEW_STATE=$(osascript -e "tell application \"$APP\" to get player state as string" 2>/dev/null)
    if [ "$NEW_STATE" = "playing" ]; then
      sketchybar --set media icon=󰎈
    else
      sketchybar --set media icon=󰏤
    fi
    ;;
esac
