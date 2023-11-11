#!/usr/bin/env bash

TINY2040_VOLUME="/Volumes/CIRCUITPY"

while true; do
    if [ -d "$TINY2040_VOLUME" ]; then
        echo "Tiny2040 detected. Unmounting..."
        diskutil unmount "$TINY2040_VOLUME"
    fi
    sleep 5 # Check every 5 seconds
done

