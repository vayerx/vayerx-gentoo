#!/bin/sh

xrandr \
    --dpi 130 \
    --output eDP1 \
        --primary \
        --mode 1920x1080 \
        --pos 0x1080 \
        --scale 1x1 \
        --rotate normal \
    --output HDMI1 \
        --mode 1920x1080 \
        --scale 1x1 \
        --pos 0x0 \
        --rotate normal \
    --output DP1 \
        --off \
    --output HDMI2 \
        --off
