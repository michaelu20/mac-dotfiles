#!/bin/bash
# Only notify Sketchybar of the change, don't force Zen Mode
/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"
