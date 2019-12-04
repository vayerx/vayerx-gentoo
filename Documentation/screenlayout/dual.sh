#!/bin/sh

xrandr \
    --output eDP1 \
        --primary \
        --mode 1920x1080 \
        --pos 0x1080 \
        --dpi 157 \
        --rotate normal \
    --output HDMI1 \
        --mode 1920x1080 \
        --pos 0x0 \
        --dpi 93 \
        --rotate normal \
    --output DP1 \
        --off \
    --output HDMI2 \
        --off
