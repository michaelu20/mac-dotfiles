#!/bin/bash

EXPANDED_FILE="/tmp/sketchybar_media_expanded"

is_expanded() {
  [ "$(cat "$EXPANDED_FILE" 2>/dev/null)" = "1" ]
}

update_display() {
  local state="$1" title="$2" artist="$3" app="$4"

  echo "$app"   > /tmp/sketchybar_media_app
  echo "$state" > /tmp/sketchybar_media_state

  if [ "$state" = "playing" ] || [ "$state" = "paused" ]; then
    [ -z "$title" ] && return

    local icon=󰎈
    local play_icon=󰏤
    [ "$state" = "paused" ] && icon=󰏤 && play_icon=󰐎

    sketchybar --set media drawing=on icon="$icon"
    sketchybar --set media.play icon="$play_icon"

    if is_expanded; then
      sketchybar --set media label.drawing=on label="${title} · ${artist}"
      sketchybar --set media.prev drawing=on
      sketchybar --set media.play drawing=on
      sketchybar --set media.next drawing=on
    else
      sketchybar --set media label.drawing=off
      sketchybar --set media.prev drawing=off
      sketchybar --set media.play drawing=off
      sketchybar --set media.next drawing=off
    fi
  else
    echo "0" > "$EXPANDED_FILE"
    sketchybar --set media      drawing=off label.drawing=off
    sketchybar --set media.prev drawing=off
    sketchybar --set media.play drawing=off
    sketchybar --set media.next drawing=off
  fi
}

poll_music() {
  if osascript -e 'tell application "Music" to running' 2>/dev/null | grep -q true; then
    STATE=$(osascript  -e 'tell application "Music" to get player state as string' 2>/dev/null)
    if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
      TITLE=$(osascript  -e 'tell application "Music" to get name of current track' 2>/dev/null)
      ARTIST=$(osascript -e 'tell application "Music" to get artist of current track' 2>/dev/null)
      update_display "$STATE" "$TITLE" "$ARTIST" "Music"
      return
    fi
  fi

  if osascript -e 'tell application "Spotify" to running' 2>/dev/null | grep -q true; then
    STATE=$(osascript  -e 'tell application "Spotify" to get player state as string' 2>/dev/null)
    if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
      TITLE=$(osascript  -e 'tell application "Spotify" to get name of current track' 2>/dev/null)
      ARTIST=$(osascript -e 'tell application "Spotify" to get artist of current track' 2>/dev/null)
      update_display "$STATE" "$TITLE" "$ARTIST" "Spotify"
      return
    fi
  fi

  echo "0" > "$EXPANDED_FILE"
  sketchybar --set media      drawing=off label.drawing=off
  sketchybar --set media.prev drawing=off
  sketchybar --set media.play drawing=off
  sketchybar --set media.next drawing=off
}

case "$SENDER" in
  "media_change")
    STATE=$(echo  "$INFO" | jq -r '.state  // "stopped"')
    TITLE=$(echo  "$INFO" | jq -r '.title  // ""')
    ARTIST=$(echo "$INFO" | jq -r '.artist // ""')
    APP=$(echo    "$INFO" | jq -r '.app    // ""')
    update_display "$STATE" "$TITLE" "$ARTIST" "$APP"
    ;;
  "routine"|"forced")
    poll_music
    ;;
esac
