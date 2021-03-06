#!/bin/bash

# Source: https://wiki.archlinux.org/title/Polybar#Running_with_WM

# Terminate already running bar instances
killall -q polybar

# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config
polybar example 2>&1 | tee -a /tmp/polybar.log & disown
