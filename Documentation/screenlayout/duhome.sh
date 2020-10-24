#!/bin/sh

xrandr \
    --output eDP1 \
        --primary \
        --mode 1920x1080 \
        --pos 0x1200 \
        --rotate normal \
    --output HDMI1 \
        --mode 1920x1200 \
        --pos 0x0 \
        --rotate normal \
    --output DP1 \
        --off \
    --output HDMI2 \
        --off
