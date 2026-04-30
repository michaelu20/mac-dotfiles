#!/bin/bash

# Use absolute paths
SB="/opt/homebrew/bin/sketchybar"
AS="/opt/homebrew/bin/aerospace"
JQ="/opt/homebrew/bin/jq"

FONT="JetBrainsMono Nerd Font"
WORKSPACE="$1"

# 1. Get Focus Info (Fallback to direct query if env var is empty)
FOCUSED="$FOCUSED_WORKSPACE"
if [ -z "$FOCUSED" ]; then
    FOCUSED=$($AS list-workspaces --focused 2>/dev/null)
fi

# 2. Check if Zen Mode is ON (Correcting the JQ path)
ZEN_ON=$($SB --query clock | $JQ -r '.geometry.drawing == "off"')

source "$HOME/.config/sketchybar/icon_map.sh"

# If Zen Mode is ON, keep EVERYTHING hidden and exit
if [ "$ZEN_ON" = "true" ]; then
  $SB --set space.$WORKSPACE drawing=off
  $SB --set apps.$WORKSPACE drawing=off
  exit 0
fi

# 3. Determine if workspace has windows
HAS_WINDOWS=$($AS list-workspaces --monitor all --empty no 2>/dev/null | grep -c "^${WORKSPACE}$")

# 4. Empty and not focused — show as dot
if [ "$HAS_WINDOWS" -eq 0 ] && [ "$WORKSPACE" != "$FOCUSED" ]; then
  case "$WORKSPACE" in
    1) COLOR=0xffcba6f7 ;; 2) COLOR=0xff89b4fa ;; 3) COLOR=0xffa6e3a1 ;;
    4) COLOR=0xfff9e2af ;; 5) COLOR=0xfff38ba8 ;; *) COLOR=0xffcba6f7 ;;
  esac
  $SB --set space.$WORKSPACE drawing=on \
    icon=● \
    icon.font="$FONT:Bold:8.0" \
    icon.padding_left=4 \
    icon.padding_right=4 \
    padding_left=2 \
    padding_right=2 \
    background.color=0xff313244 \
    background.height=14 \
    icon.color=$COLOR
  $SB --set apps.$WORKSPACE drawing=off
  exit 0
fi

# 5. Show and Style
$SB --set space.$WORKSPACE drawing=on

case "$WORKSPACE" in
  1) COLOR=0xffcba6f7 ;; # Mauve
  2) COLOR=0xff89b4fa ;; # Blue
  3) COLOR=0xffa6e3a1 ;; # Green
  4) COLOR=0xfff9e2af ;; # Yellow
  5) COLOR=0xfff38ba8 ;; # Red
  *) COLOR=0xffcba6f7 ;;
esac

# Build app icon string
WINDOWS=$($AS list-windows --workspace "$WORKSPACE" --json 2>/dev/null)
ICONS=""
SEEN_APPS=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  if [[ ! "$SEEN_APPS" =~ "$app" ]]; then
    SEEN_APPS="$SEEN_APPS|$app"
    __icon_map "$app"
    ICONS="$ICONS$icon_result "
  fi
done < <(echo "$WINDOWS" | $JQ -r '.[]["app-name"] // ""' 2>/dev/null)
ICONS="${ICONS% }"

if [ "$WORKSPACE" = "$FOCUSED" ]; then
  # FOCUSED STATE — app icons in colored pill
  if [ -n "$ICONS" ]; then
    $SB --set space.$WORKSPACE \
      icon="$ICONS" \
      icon.font="sketchybar-app-font:Regular:14.0" \
      icon.padding_left=8 \
      icon.padding_right=8 \
      padding_left=6 \
      padding_right=6 \
      background.color=$COLOR \
      background.height=20 \
      icon.color=0xff1e1e2e
  else
    $SB --set space.$WORKSPACE \
      icon=󰧨 \
      icon.font="$FONT:Bold:14.0" \
      icon.padding_left=8 \
      icon.padding_right=8 \
      padding_left=6 \
      padding_right=6 \
      background.color=$COLOR \
      background.height=20 \
      icon.color=0xff1e1e2e
  fi
else
  # UNFOCUSED WITH WINDOWS — smaller app icons, muted
  if [ -n "$ICONS" ]; then
    $SB --set space.$WORKSPACE \
      icon="$ICONS" \
      icon.font="sketchybar-app-font:Regular:12.0" \
      icon.padding_left=6 \
      icon.padding_right=6 \
      padding_left=4 \
      padding_right=4 \
      background.color=0xff313244 \
      background.height=18 \
      icon.color=$COLOR
  else
    $SB --set space.$WORKSPACE \
      icon=● \
      icon.font="$FONT:Bold:8.0" \
      icon.padding_left=4 \
      icon.padding_right=4 \
      padding_left=2 \
      padding_right=2 \
      background.color=0xff313244 \
      background.height=14 \
      icon.color=$COLOR
  fi
fi
$SB --set apps.$WORKSPACE drawing=off
